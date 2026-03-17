# System Architecture — Complete (Rounds 1-10)

## Architecture Diagram

https://diashort.apps.quickable.co/d/9bca89e7
*(Diagram needs update — see evolution notes below for new components)*

---

## Evolution Summary

| Round | Change | Architectural Impact |
|-------|--------|---------------------|
| S-01 | Base check-in | 3 services, 1 DB, 1 search index, 1 event bus, 1 WebSocket server |
| S-02 | WebSocket bug | WebSocket fallback to polling. Connection health. Event delivery guarantees. |
| S-03 | Mobile pre-check-in | Appointment Service integration. SMS/email link generation. Identity verification gate. Mobile-responsive client. |
| S-04 | Data leak / HIPAA | Client-side state purge protocol. Session termination triggers. Encryption audit. |
| S-05 | Multi-location | Location context on all entities. Centralized DB serving N locations. Location-aware routing. |
| S-06 | Medications | New data category. HIS integration (future). Variable-length structured data. |
| S-07 | Concurrent finalization | Optimistic locking on finalization. Version column. Conflict resolution API. Session recovery. |
| S-08 | Photo upload | Object storage for PHI images. OCR pipeline service. Image processing queue. |
| S-09 | Performance | Connection pooling. Read replicas for search. Caching layer. Horizontal scaling for Check-in Service. |
| S-10 | Acquisition/import | Migration pipeline service. Dedup algorithm. Bulk import throttling. Search index rebuild. |

---

## Components

### Client Layer

| Component | Actor | Protocol | Notes |
|-----------|-------|----------|-------|
| Receptionist UI | Receptionist | REST + WebSocket | Desktop browser. Screens S1, S1b, S2, S3R, S4, S5, S8, S9. |
| Patient Kiosk UI | Patient | REST + WebSocket | Tablet/kiosk. Screens S0, S3P, S4. Token-scoped access. |
| Patient Mobile UI | Patient | REST + WebSocket | Phone browser. Screens S7, S6, S3P, S4. Responsive. Same codebase as kiosk, responsive layout. |
| Admin UI | Admin | REST | Desktop browser. Screens S10, S11, S12, S13. Session-authenticated. |

**S-04 addition — Client-side state purge protocol:**
Every session termination (finalize, timeout, cancel) triggers:
1. DOM purge — all PHI elements removed from DOM
2. JavaScript memory — all patient data variables nullified
3. Browser history — `replaceState` so back button shows S0
4. Autocomplete — form autocomplete data cleared
5. Session token — deleted from client memory
6. Cache — any client-side cache entries for this session purged

This is enforced by a `SessionPurge` module that runs synchronously before any screen transition away from S3P. The kiosk transitions to S0 (Welcome). The mobile client shows completion (S4) then purge happens on tab close.

### API Gateway

Single entry point. Routes requests to services. Handles:
- Authentication (receptionist: session-based; admin: session-based with role check)
- Token validation (patient: bearer token from check-in session)
- Rate limiting:
  - Search: 10 req/s per receptionist
  - Photo upload: 2 req/min per session (prevents abuse)
  - Pre-check-in link verification: 5 req/min per IP (brute force prevention, S-03)
  - Bulk import: throttled by Migration Service, not gateway
- **S-05:** Location context header — `X-Location-Id` injected from receptionist's session config
- **S-09:** Circuit breaker on downstream services — if Check-in Service is overloaded, return 503 with retry-after header

### Services

#### Patient Service
- **Owns:** Patient records, patient data (per-category), visit history, data categories.
- **Reads:** PatientData with staleness computation. Location-aware visit history (S-05).
- **Writes:** Patient record CRUD. Applies staged updates from check-in sessions on finalization. Applies merge results (S-10).
- **Events emitted:** `patient.created`, `patient.updated`, `patient.merged`, `patient.imported`.
- **S-05 change:** Visit history includes `location_id`. Patient records are location-independent — no sharding by location.
- **S-06 change:** New data category `medications` with `freshness_days = 0`. Value schema is variable-length array.
- **S-10 change:** Bulk import endpoint for migration. Provenance tracking on imported records.

#### Check-in Service
- **Owns:** Check-in sessions, check-in sections.
- **Reads:** Patient data (via Patient Service) to build confirmation view.
- **Writes:** Section confirmations, section updates (staged), session lifecycle.
- **Events emitted:** `checkin.created`, `checkin.section.updated`, `checkin.patient.complete`, `checkin.finalized`, `checkin.expired`, `checkin.conflict` (S-07).
- **S-02 change:** Polling fallback endpoint for receptionist when WebSocket is down. `GET /api/checkins/{id}/poll` returns current state without WebSocket.
- **S-03 change:** Mobile pre-check-in session creation via link token. Identity verification gate. Appointment-linked sessions.
- **S-05 change:** Session includes `location_id`. Concurrent check-in prevention is cross-location (unique constraint is on `patient_id`, not `patient_id + location_id`).
- **S-07 change:** Finalization uses optimistic locking. `version` column on `checkin_sessions`. Conflict detection at finalization time. Conflict resolution endpoints.
- **S-09 change:** Horizontally scalable. Stateless — all state in DB. Connection pool sized for peak (30 concurrent per location, 60 aggregate).

#### Search Service
- **Owns:** Search index (derived from Patient Service data).
- **Reads:** Index for patient lookup.
- **Writes:** None directly. Rebuilds index from Patient Service events.
- **Two modes:**
  - **Standard search** (S1): prefix match on name, exact match on DOB. <200ms.
  - **Fuzzy search** (S1b): Levenshtein on names, partial DOB, phone/email lookup. <500ms. Confidence scores.
- **S-05 change:** Results include `last_visit_location`. Search is cross-location by default.
- **S-09 change:** Read replica for search queries during peak. Index optimized for prefix queries.
- **S-10 change:** Bulk index rebuild after Riverside import. ~4,000 additional records. Index must handle gracefully without degrading live queries.

#### Notification Service (NEW — S-03)
- **Owns:** Pre-check-in link generation and delivery.
- **Reads:** Appointment data (from Appointment Service or external scheduling system).
- **Writes:** Link records (token, appointment_id, status, expiry).
- **Integrations:** SMS gateway, email service.
- **Key behavior:**
  - Generates pre-check-in links 24 hours before appointment.
  - Link contains a one-time token mapped to appointment + patient.
  - Tracks link status: generated, sent, opened, completed, expired, locked.
  - Rate-limited delivery: no duplicate sends for the same appointment.

#### OCR Service (NEW — S-08)
- **Owns:** Image processing pipeline for insurance card extraction.
- **Reads:** Uploaded images from Object Storage.
- **Writes:** Extracted field data back to Check-in Service (as a section update).
- **Pipeline:**
  1. Image received -> stored in Object Storage (encrypted, PHI)
  2. Image quality check (blur, lighting, card detection)
  3. OCR extraction (provider name, policy number, group number, member name)
  4. Confidence scoring per field
  5. Result returned to client for patient verification
- **Technology:** Cloud OCR API (AWS Textract, Azure Form Recognizer, or equivalent). NOT a custom ML model.
- **Fallback:** If OCR confidence < 60% on any critical field, prompt patient to re-take photo or enter manually.

#### Migration Service (NEW — S-10)
- **Owns:** Bulk import pipeline, duplicate detection, merge workflow.
- **Reads:** Import source data (Riverside EHR export, paper record entries).
- **Writes:** Patient records via Patient Service (throttled).
- **Pipeline:**
  1. Parse source data (CSV/HL7/FHIR from EHR, JSON from paper entry)
  2. Normalize fields (name standardization, date format, address normalization)
  3. Dedup check — run against existing patient index
  4. If no duplicate: import directly via Patient Service
  5. If potential duplicate: flag for human review (S11)
  6. Track import progress, errors, duplicates
- **Dedup algorithm:**
  - Exact match: same first_name + last_name + DOB = 100% confidence
  - High confidence (>90%): same DOB + similar name (Levenshtein <= 1) OR same name + DOB within 1 year + same phone
  - Medium (60-90%): similar name + same DOB OR same phone + similar name
  - Low (<60%): same last name + same DOB year OR same phone
  - Configurable thresholds. Auto-import at 0% (no match). Auto-merge at 100%. Everything else queued for review.
- **Throttling:** Max 10 imports/second to avoid degrading production. Pauses during peak hours (configurable). Respects BOX-39.

### Data Layer

#### Patient Store (primary)
- PostgreSQL. Single instance serving all locations (S-05).
- Tables: `patients`, `patient_data`, `visits`, `data_categories`, `locations` (S-05), `patient_provenance` (S-10).
- Encrypted at rest (AES-256). HIPAA-compliant (S-04, BOX-14).
- Row-level audit via `patient_data_audit` table.
- **S-09:** Read replica for search-related queries. Connection pool: 50 connections primary, 20 connections replica.

#### Check-in Store
- Same PostgreSQL instance, separate schema.
- Tables: `checkin_sessions`, `checkin_sections`, `pre_checkin_links` (S-03), `session_conflicts` (S-07).
- Short-lived data. Sessions older than 24 hours archived, older than 90 days purged.
- **S-07 addition:** `session_conflicts` records all finalization conflicts for recovery and audit.

#### Object Storage (NEW — S-08)
- S3-compatible object storage.
- Bucket: `phi-documents` — insurance card images, scanned paper records (S-10).
- Encrypted at rest (AES-256, server-side encryption).
- Lifecycle policy: images older than 7 years deleted (HIPAA retention).
- Access: only OCR Service and Admin UI (for paper record viewing). No direct patient/receptionist access — images served through signed URLs with 5-minute expiry.

#### Search Index
- Elasticsearch or equivalent.
- Indexes: patient name (analyzed), DOB, phone, email, insurance ID, last_visit_location (S-05).
- Refreshed from Patient Service events. Eventually consistent (<2s lag).
- **S-10:** Index rebuild strategy — incremental. Each imported patient indexed individually. No full reindex required.

#### Cache Layer (NEW — S-09)
- Redis (same instance as event bus, separate DB).
- Caches:
  - Patient summary for S2: key `patient:{id}:summary`, TTL 5 minutes. Invalidated on `patient.updated` event.
  - Data categories config: key `data_categories`, TTL 1 hour. Rarely changes.
  - Session state for polling fallback (S-02): key `checkin:{id}:state`, TTL 30 seconds. Updated on every section action.
- Cache-aside pattern. Read from cache, fallback to DB, populate cache on miss.

### Infrastructure

#### WebSocket Server
- Maintains connections for active check-in sessions.
- **S-02 changes:**
  - Heartbeat: server sends ping every 15 seconds. Client must respond within 5 seconds or connection is marked dead.
  - Auto-reconnect: client implements exponential backoff (1s, 2s, 4s, 8s, max 30s). Max retry: 10 attempts.
  - Fallback: if reconnection fails after 10 attempts, client switches to REST polling (every 10 seconds).
  - Connection health: server tracks connection state (connected, heartbeat_missed, disconnected). Receptionist UI shows indicator.
- **S-05:** WebSocket connections are location-independent. A receptionist at Location A can monitor a session created at Location B (if viewing cross-location queue).
- **S-09:** Connection pool limited to 200 concurrent WebSocket connections per server instance. At 30 sessions/location x 2 connections/session (receptionist + patient), single location needs 60 connections. Two locations need 120. Headroom for growth.

#### Event Bus
- Redis Streams.
- Topics: `patient.*`, `checkin.*`, `import.*` (S-10), `ocr.*` (S-08).
- **S-02 change:** Consumer groups with at-least-once delivery. Each consumer acknowledges after processing. Unacknowledged messages re-delivered after 60 seconds.
- Consumers:
  - Search Service: rebuilds index entries
  - WebSocket Server: pushes to connected clients
  - Audit Service: logs events
  - Migration Service (S-10): monitors import progress
  - Notification Service (S-03): triggers pre-check-in link generation on appointment creation

#### Appointment Service Integration (NEW — S-03)
- External system integration (not owned by us).
- Read-only access to appointment schedule.
- Polling or webhook: get upcoming appointments for pre-check-in link generation.
- Data needed: patient_id, appointment_date, appointment_time, location_id, physician_id.
- If no appointment system exists: pre-check-in links can be generated manually by receptionist.

---

## Data Model

### Core Tables (evolved from S-01)

#### `patients`
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| first_name | VARCHAR(100) | |
| last_name | VARCHAR(100) | |
| dob | DATE | |
| photo_url | VARCHAR(500) | Nullable |
| phone | VARCHAR(20) | Nullable |
| email | VARCHAR(200) | Nullable |
| created_at | TIMESTAMP | |
| merge_flag | VARCHAR(20) | Nullable. "possible_duplicate", "imported", "merged" |
| **source_system** | VARCHAR(50) | **S-10.** "native", "riverside_ehr", "riverside_paper". Default "native". |
| **source_id** | VARCHAR(100) | **S-10.** Original ID from source system. Nullable. |
| **imported_at** | TIMESTAMP | **S-10.** When this record was imported. Nullable for native records. |

#### `patient_data`
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients |
| category | VARCHAR(50) | "address", "insurance", "allergies", **"medications"** (S-06) |
| value | JSONB | Flexible structure per category |
| last_confirmed | TIMESTAMP | When this data was last confirmed |
| confirmed_by | UUID | FK -> users or "patient" sentinel |
| source | VARCHAR(20) | "intake", "checkin_confirm", "checkin_update", "receptionist_edit", **"import"** (S-10), **"ocr_extract"** (S-08) |
| **provenance** | VARCHAR(100) | **S-10.** "native", "riverside_import", "merged:{source_record_ids}". Nullable. |

Category-specific value schemas:

- **address:** `{"line1": "", "line2": "", "city": "", "state": "", "zip": ""}`
- **insurance:** `{"provider": "", "policy_number": "", "group_number": "", "member_name": "", "card_image_front": "s3://...", "card_image_back": "s3://..."}` *(S-08: card_image fields added)*
- **allergies:** `{"items": [{"name": "", "severity": "", "reaction": ""}]}`
- **medications:** `{"items": [{"drug_name": "", "dosage": "", "frequency": "", "prescriber": ""}], "confirmed_empty": false}` *(S-06: new category)*

#### `data_categories`
| Column | Type | Notes |
|--------|------|-------|
| name | VARCHAR(50) | PK |
| freshness_days | INTEGER | Nullable. address=365, insurance=180, allergies=null, **medications=0** (S-06) |
| **required_every_visit** | BOOLEAN | **S-06.** True for medications. False for others. |
| **display_order** | INTEGER | Rendering order in S3P. |

#### `locations` (NEW — S-05)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| name | VARCHAR(200) | "Main Street Clinic", "Riverside Office" |
| address | JSONB | Location address |
| timezone | VARCHAR(50) | Location timezone |
| is_active | BOOLEAN | Default true. Can deactivate locations. |
| created_at | TIMESTAMP | |

#### `visits` (modified — S-05)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients |
| **location_id** | UUID | **S-05.** FK -> locations |
| visit_date | TIMESTAMP | |
| physician_id | UUID | FK -> physicians |

#### `checkin_sessions` (modified — S-03, S-05, S-07)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients. Unique partial index on active sessions. |
| initiated_by | UUID | FK -> users. Nullable for mobile pre-check-in (S-03). |
| **location_id** | UUID | **S-05.** FK -> locations. |
| status | VARCHAR(20) | "pending", "in_progress", "patient_complete", "finalized", "expired", **"conflict"** (S-07) |
| **channel** | VARCHAR(20) | **S-03.** "kiosk" or "mobile". |
| access_token | VARCHAR(64) | Hashed in DB. |
| created_at | TIMESTAMP | |
| last_activity_at | TIMESTAMP | |
| patient_completed_at | TIMESTAMP | Nullable. |
| finalized_at | TIMESTAMP | Nullable. |
| finalized_by | UUID | **S-07.** FK -> users. Who finalized. |
| expires_at | TIMESTAMP | created_at + 30 minutes. |
| **version** | INTEGER | **S-07.** Optimistic locking. Starts at 1. Incremented on every state change. |
| **appointment_id** | UUID | **S-03.** FK to external appointment system. Nullable (kiosk sessions don't require appointment). |
| **pre_checkin_link_id** | UUID | **S-03.** FK -> pre_checkin_links. Nullable. |

**Unique partial index (S-07 refined):**
```sql
CREATE UNIQUE INDEX idx_one_active_session_per_patient
ON checkin_sessions (patient_id)
WHERE status IN ('pending', 'in_progress', 'patient_complete');
```

#### `checkin_sections` (modified — S-06, S-08)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| session_id | UUID | FK -> checkin_sessions |
| category | VARCHAR(50) | Matches patient_data.category. Includes "medications" (S-06). |
| status | VARCHAR(20) | "pending", "confirmed", "updated", "missing_filled" |
| original_value | JSONB | Snapshot at session creation. |
| confirmed_value | JSONB | New value if updated/filled. |
| acted_at | TIMESTAMP | Nullable. |
| **card_image_ids** | UUID[] | **S-08.** References to uploaded images in object storage. Insurance category only. |

#### `pre_checkin_links` (NEW — S-03)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients |
| appointment_id | UUID | External appointment ID |
| location_id | UUID | FK -> locations |
| token | VARCHAR(64) | Hashed in DB. Unique. |
| status | VARCHAR(20) | "generated", "sent", "opened", "completed", "expired", "locked" |
| opens_at | TIMESTAMP | 24 hours before appointment. |
| expires_at | TIMESTAMP | Appointment time. |
| verification_attempts | INTEGER | Default 0. Max 3 before lockout. |
| created_at | TIMESTAMP | |
| completed_at | TIMESTAMP | Nullable. |

#### `session_conflicts` (NEW — S-07)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients |
| winning_session_id | UUID | FK -> checkin_sessions. The session that finalized first. |
| losing_session_id | UUID | FK -> checkin_sessions. The session that was rejected. |
| winning_data | JSONB | Snapshot of applied changes. |
| losing_data | JSONB | Snapshot of rejected changes. |
| resolution | VARCHAR(20) | "pending", "applied", "discarded", "partial" |
| resolved_by | UUID | FK -> users. Nullable. |
| resolved_at | TIMESTAMP | Nullable. |
| created_at | TIMESTAMP | |

#### `import_batches` (NEW — S-10)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| source_system | VARCHAR(50) | "riverside_ehr", "riverside_paper" |
| total_records | INTEGER | Total records in source. |
| imported | INTEGER | Successfully imported. |
| errors | INTEGER | Failed to import. |
| duplicates_flagged | INTEGER | Flagged for human review. |
| status | VARCHAR(20) | "pending", "in_progress", "paused", "completed", "failed" |
| started_at | TIMESTAMP | |
| completed_at | TIMESTAMP | Nullable. |
| import_rate_limit | INTEGER | Records per second. Default 10. |

#### `import_records` (NEW — S-10)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| batch_id | UUID | FK -> import_batches |
| source_data | JSONB | Original data from source system. |
| normalized_data | JSONB | After normalization pipeline. |
| status | VARCHAR(20) | "pending", "imported", "duplicate_flagged", "error", "skipped" |
| patient_id | UUID | FK -> patients. Set after successful import or merge. |
| duplicate_candidate_id | UUID | FK -> patients. The existing patient this might duplicate. |
| duplicate_confidence | DECIMAL(3,2) | 0.00 to 1.00. |
| error_message | TEXT | If status = "error". |
| created_at | TIMESTAMP | |

#### `document_uploads` (NEW — S-08)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| session_id | UUID | FK -> checkin_sessions |
| patient_id | UUID | FK -> patients |
| document_type | VARCHAR(20) | "insurance_card_front", "insurance_card_back" |
| storage_key | VARCHAR(500) | S3 key. |
| ocr_status | VARCHAR(20) | "pending", "processing", "completed", "failed" |
| ocr_result | JSONB | Extracted fields with per-field confidence. |
| uploaded_at | TIMESTAMP | |

#### `patient_data_audit` (unchanged, extended scope)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients |
| category | VARCHAR(50) | |
| old_value | JSONB | |
| new_value | JSONB | |
| changed_by | VARCHAR(100) | User ID, "patient", "system", "import", "merge" |
| session_id | UUID | Nullable. |
| source | VARCHAR(20) | |
| **merge_source_ids** | UUID[] | **S-10.** If change came from a merge, the source record IDs. |
| created_at | TIMESTAMP | |

**Retention:** 7 years per HIPAA (BOX-15, PM confirmed).

---

## Key Design Decisions (evolved)

1. **Staleness is computed, not stored.** Unchanged from S-01. Adding medications with `freshness_days = 0` works immediately — every read computes staleness.

2. **Check-in sections are snapshots.** Unchanged. On finalization, if the patient record has been modified since the snapshot, a conflict is flagged.

3. **Access token is hashed.** Unchanged. Extended to pre-check-in link tokens (S-03).

4. **Audit is append-only.** 7-year retention confirmed (S-04, HIPAA).

5. **Location is context, not boundary (S-05).** Patient records are NOT partitioned by location. A single patient table serves all locations. Location appears as a context attribute on sessions, visits, and queue views. This means multi-location is a configuration change, not a schema change.

6. **Medications are a first-class data category (S-06).** Not a special case — they follow the same `patient_data` pattern as address/insurance/allergies. The difference is: `freshness_days = 0` (always stale) and `required_every_visit = true`. The value schema supports variable-length arrays. The `confirmed_empty` flag distinguishes "no medications" from "patient hasn't reviewed medications."

7. **Finalization uses optimistic locking (S-07).** The `version` column on `checkin_sessions` prevents lost updates. Finalization reads the current version, applies changes, and updates with `WHERE version = {read_version}`. If another finalization happened first, the version won't match, and the second finalization fails with a conflict. This replaces the S-01 approach of relying solely on the unique partial index for concurrent prevention — the index prevents concurrent *sessions*, but the version prevents concurrent *finalizations* of the same session.

8. **OCR is an async pipeline, not synchronous (S-08).** Photo upload returns immediately with an upload receipt. OCR processing happens asynchronously. Client polls for result. Typical OCR latency: 2-5 seconds. Patient sees a spinner. If OCR takes >10 seconds, client offers "Enter manually" fallback.

9. **Import is throttled and idempotent (S-10).** Each import record has a source_id. Re-importing the same source_id is a no-op. Import rate is configurable and defaults to 10 records/second. Import pauses during peak hours. This ensures BOX-39 (no production degradation).

10. **Cache invalidation is event-driven (S-09).** The cache layer listens to `patient.updated` events and invalidates affected cache entries. This avoids stale cache reads after updates. TTL is a safety net, not the primary invalidation mechanism.

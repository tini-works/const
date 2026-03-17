# System Architecture — Story 01

## Architecture Diagram

https://diashort.apps.quickable.co/d/9bca89e7

## Components

### Client Layer

| Component | Actor | Protocol | Notes |
|-----------|-------|----------|-------|
| Receptionist UI | Receptionist | REST + WebSocket | Desktop browser. Screens S1, S1b, S2, S3R, S4. |
| Patient UI | Patient | REST + WebSocket | Tablet/kiosk. Screen S3P, S4. Accessed via token URL, no login. |

Both clients connect via WebSocket for live updates during the check-in session. The receptionist sees patient progress in real time (S3R). The patient sees nothing from the receptionist — the WebSocket is one-directional for the patient (server pushes timeout warnings only).

### API Gateway

Single entry point. Routes requests to services. Handles:
- Authentication (receptionist: session-based)
- Token validation (patient: bearer token from check-in session)
- Rate limiting (search endpoint: 10 req/s per receptionist to prevent index abuse)

### Services

#### Patient Service
- **Owns:** Patient records, patient data (per-category), visit history.
- **Reads:** PatientData with staleness computation.
- **Writes:** Patient record CRUD. Applies staged updates from check-in sessions on finalization.
- **Events emitted:** `patient.created`, `patient.updated`, `patient.merged`.
- **Key behavior:** Staleness is computed at read time against DataCategory.freshness_days. Not stored. This means changing a freshness policy retroactively affects all patients immediately — no migration needed.

#### Check-in Service
- **Owns:** Check-in sessions, check-in sections.
- **Reads:** Patient data (via Patient Service) to build confirmation view.
- **Writes:** Section confirmations, section updates (staged), session lifecycle.
- **Events emitted:** `checkin.created`, `checkin.section.updated`, `checkin.patient.complete`, `checkin.finalized`, `checkin.expired`.
- **Key behavior:** Enforces one active session per patient. Manages session expiry (30-min hard TTL, 5-min inactivity TTL). On finalization, calls Patient Service to apply staged updates.

#### Search Service
- **Owns:** Search index (derived from Patient Service data).
- **Reads:** Index for patient lookup.
- **Writes:** None directly. Rebuilds index from Patient Service events.
- **Two modes:**
  - **Standard search** (S1): prefix match on name, exact match on DOB. Fast. <200ms.
  - **Fuzzy search** (S1b): Levenshtein on names, partial DOB, phone/email lookup. Slower. <500ms. Returns confidence scores.

### Data Layer

#### Patient Store (primary)
- Relational database (PostgreSQL).
- Tables: `patients`, `patient_data`, `visits`, `data_categories`.
- Encrypted at rest (AES-256).
- Row-level audit via `patient_data_audit` table (who changed what, when, from what value).

#### Check-in Store
- Same database, separate schema.
- Tables: `checkin_sessions`, `checkin_sections`.
- Short-lived data. Sessions older than 24 hours are archived, older than 90 days are purged.

#### Search Index
- Elasticsearch or equivalent.
- Indexes: patient name (analyzed), DOB, phone, email, insurance ID.
- Refreshed from Patient Service events. Eventually consistent (<2s lag).

### Infrastructure

#### WebSocket Server
- Maintains connections for active check-in sessions.
- Receptionist subscribes to session events for their active check-in.
- Patient connection receives timeout warnings (3-min, 4-min, final).
- Connection lifetime = session lifetime. No long-lived connections.

#### Event Bus
- Lightweight pub/sub (Redis Streams or equivalent).
- Topics: `patient.*`, `checkin.*`.
- Consumers: Search Service (rebuilds index), WebSocket Server (pushes to clients), Audit Service (logs events).

## Data Model

https://diashort.apps.quickable.co/d/b8e8f816

### Core Tables

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
| merge_flag | VARCHAR(20) | Nullable. "possible_duplicate" when created via S1b fallback. |

#### `patient_data`
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients |
| category | VARCHAR(50) | "address", "insurance", "allergies" |
| value | JSONB | Flexible structure per category |
| last_confirmed | TIMESTAMP | When this data was last confirmed (by patient or receptionist) |
| confirmed_by | UUID | FK -> users (receptionist) or "patient" sentinel |
| source | VARCHAR(20) | "intake", "checkin_confirm", "checkin_update", "receptionist_edit" |

Category-specific value schemas:

- **address:** `{"line1": "", "line2": "", "city": "", "state": "", "zip": ""}`
- **insurance:** `{"provider": "", "policy_number": "", "group_number": ""}`
- **allergies:** `{"items": [{"name": "", "severity": "", "reaction": ""}]}`

#### `data_categories`
| Column | Type | Notes |
|--------|------|-------|
| name | VARCHAR(50) | PK. "address", "insurance", "allergies" |
| freshness_days | INTEGER | Threshold for staleness flag. address=365, insurance=180, allergies=null (never stale) |

Staleness computation: `CURRENT_DATE - patient_data.last_confirmed > data_categories.freshness_days`. If `freshness_days` is null, never stale.

#### `visits`
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients |
| location_id | UUID | FK -> locations |
| visit_date | TIMESTAMP | |
| physician_id | UUID | FK -> physicians |

#### `checkin_sessions`
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| patient_id | UUID | FK -> patients. Unique constraint on active sessions (status in 'pending','in_progress'). |
| initiated_by | UUID | FK -> users (receptionist) |
| status | VARCHAR(20) | "pending", "in_progress", "patient_complete", "finalized", "expired" |
| access_token | VARCHAR(64) | Cryptographically random. Used by patient to access S3P. Hashed in DB. |
| created_at | TIMESTAMP | |
| last_activity_at | TIMESTAMP | Updated on every section action. Used for 5-min inactivity timeout. |
| patient_completed_at | TIMESTAMP | Nullable. When patient tapped "All Confirmed". |
| finalized_at | TIMESTAMP | Nullable. When receptionist clicked "Complete Check-in". |
| expires_at | TIMESTAMP | created_at + 30 minutes. Hard TTL. |

#### `checkin_sections`
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| session_id | UUID | FK -> checkin_sessions |
| category | VARCHAR(50) | Matches patient_data.category |
| status | VARCHAR(20) | "pending", "confirmed", "updated", "missing_filled" |
| original_value | JSONB | Snapshot of patient_data.value at session creation. Null if missing. |
| confirmed_value | JSONB | Null if confirmed-as-is. New value if updated. Filled value if was missing. |
| acted_at | TIMESTAMP | Nullable. When patient took action on this section. |

## Key Design Decisions

1. **Staleness is computed, not stored.** Changing the freshness policy for insurance from 180 to 90 days takes effect immediately for all patients. No data migration.

2. **Check-in sections are snapshots.** When a session is created, the current patient data is snapshotted into `checkin_sections.original_value`. This means the patient sees the data as it was when check-in started, even if a receptionist edits the record concurrently on another terminal. On finalization, if the patient record has been modified since the snapshot, a conflict is flagged (see BOX-E5 — this is also why we prevent concurrent sessions).

3. **Access token is hashed.** The raw token is returned once (to the receptionist, who passes it to the patient's device). The database stores only the hash. This means we can't "look up" a session by token — we hash the presented token and find the matching row. This prevents token leakage via database access.

4. **Audit is append-only.** The `patient_data_audit` table receives a row on every change. Old value, new value, who, when, source. Never updated, never deleted. Retention policy TBD per PM.

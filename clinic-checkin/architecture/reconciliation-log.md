# Reconciliation Log — Engineer Vertical

Changes triggered by bugs, new requirements, or cross-vertical shifts that required re-evaluation of architecture items.

---

## Entry 1: BUG-001 Sync Failure (Round 2)

**Date:** 2024-10-18
**Trigger:** [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen) — kiosk showed green checkmark without confirming receptionist dashboard received the data. Patients thought they were done; receptionists saw nothing.

**Impact assessment:** Core check-in completion flow was unreliable. Any endpoint or client assuming fire-and-forget WebSocket delivery was suspect.

**Items re-evaluated:**
- API spec: `POST /checkins/{id}/complete` response shape (needed `sync_status` field)
- API spec: WebSocket message format (needed ack mechanism)
- Data model: `check_ins` table (needed `sync_status`, `synced_at` columns)

**Items added/updated:**
- [ADR-001](adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates) created — WebSocket with ack + polling fallback
- API spec Section 8 (Real-Time Updates) rewritten with ack protocol
- `check_ins` schema updated with sync tracking fields
- Diagram: [Kiosk-to-Receptionist Sync](diagrams.md#kiosk-to-receptionist-sync-bug-001-fix) added

**Result:** End-to-end sync confirmation eliminates false green checkmarks. Kiosk now shows yellow warning on timeout instead of lying.

**Assessed by:** Alex Kim (Tech Lead), Priya Patel (Senior Engineer)

---

## Entry 2: BUG-002 PHI Exposure (Round 4)

**Date:** 2024-11-05
**Trigger:** [BUG-002](../product/user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan) — P0 security incident. Patient B briefly saw Patient A's name and allergies on kiosk screen during session transition. PHI exposure, potentially HIPAA-reportable.

**Impact assessment:** Every kiosk code path touching patient data was suspect. React state lifecycle, DOM rendering, and browser caching all needed review. Trust in the kiosk product was at risk.

**Items re-evaluated:**
- Kiosk client architecture (state management, component lifecycle)
- API spec: all kiosk-facing endpoints (needed to confirm no cached responses were served cross-session)

**Items added/updated:**
- [ADR-002](adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation) created — session purge protocol
- [Tech Design: Session Isolation](tech-design-session-isolation.md) created — three-layer defense (state reset, DOM destruction, transition screen barrier)
- Test cases TC-301 through TC-305 added to quality vertical
- P0 monitoring alert added for data leak detection

**Result:** Deterministic session isolation via full purge protocol. Defense-in-depth design means even if a future state management bug is introduced, the transition screen prevents data leakage.

**Assessed by:** Priya Patel (Senior Engineer), Chen Wei (QA Lead)

---

## Entry 3: BUG-003 Concurrent Edit Data Loss (Round 7)

**Date:** 2024-11-25
**Trigger:** [BUG-003](../product/user-stories.md#bug-003-concurrent-edit-causes-silent-data-loss) — two receptionists edited the same patient record simultaneously. Last write won silently, overwriting the first receptionist's insurance change.

**Impact assessment:** Any write endpoint without concurrency control was suspect. The `PATCH /patients/{id}` endpoint, migration merge writes, and any future bulk-update operations all needed protection.

**Items re-evaluated:**
- API spec: `PATCH /patients/{id}` (needed `version` field requirement and 409 conflict response)
- Data model: `patients` table (needed `version` column)

**Items added/updated:**
- [ADR-003](adrs.md#adr-003-optimistic-concurrency-control-via-version-field) created — optimistic locking via version field
- `patients` table: added `version INTEGER NOT NULL DEFAULT 1`
- `patient_record_versions` table created for audit trail and conflict resolution display
- API spec: `PATCH /patients/{id}` updated with version requirement and 409 response shape
- Diagram: [Optimistic Concurrency Control](diagrams.md#optimistic-concurrency-control-bug-003-fix) added
- Test cases TC-701 through TC-705 added

**Result:** No silent data loss. Every concurrent write conflict is detected and surfaced to the user with a resolution UI.

**Assessed by:** Alex Kim (Tech Lead), Chen Wei (QA Lead)

---

## Entry 4: Scaling Crisis (Round 9)

**Date:** 2024-12-15
**Trigger:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) — Monday morning peak: 30 concurrent sessions caused kiosk freezes, slow search, dashboard stalls. Two patients left the clinic. Second location opening would make it worse.

**Impact assessment:** Infrastructure-wide. Database connections, search queries, and WebSocket broadcast all hit limits simultaneously. Every read-heavy endpoint and the dashboard were affected.

**Items re-evaluated:**
- Data model: patient search indexes (none existed for fuzzy search)
- API spec: `GET /dashboard/queue` and `GET /dashboard/search` (performance characteristics)
- Architecture: single-database model under concurrent load
- WebSocket broadcast scope (was global, needed per-location)

**Items added/updated:**
- [ADR-007](adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) created — PgBouncer, read replicas, Redis cache, search indexes, WebSocket batching
- [Tech Design: Scaling](tech-design-scaling.md) created — bottleneck analysis, PgBouncer config, read replica routing, caching strategy, rollout plan
- Data model: composite index `idx_patients_last_first`, trigram index `idx_patients_name_trgm` added
- Architecture overview: updated with read replica, caching layer, connection pooling sections
- Monitoring: new metrics for p95 response time, DB pool utilization, cache hit rate, replica lag

**Result:** Projected to handle 50 concurrent sessions with p95 < 2 seconds. All optimizations are infrastructure/configuration changes — no architecture rewrite needed.

**Assessed by:** Alex Kim (Tech Lead), Priya Patel (Senior Engineer)

---

## Entry 5: Riverside Acquisition (Round 10)

**Date:** 2024-12-22
**Trigger:** [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge), Epic [E5](../product/epics.md#e5-riverside-practice-acquisition) — acquiring Riverside Family Practice with 4,000 patient records (2,000 electronic, 2,000 paper). 5-15% overlap with existing patients.

**Impact assessment:** Largest single change to the system. New service (Migration Service), new data model tables, extended OCR service, new admin screens. Existing patient record schema needed migration tracking fields. Version mechanism (ADR-003) needed to work with merge writes.

**Items re-evaluated:**
- Data model: `patients` table (needed `migration_source`, `migration_record_id`, `patient_confirmed`, `data_confidence` fields)
- Data model: clinical tables `allergies`, `medications`, `insurance_records` (needed `source` and `data_confidence` fields)
- ADR-003 version mechanism (confirmed: merge writes use same optimistic locking)
- ADR-006 OCR service (confirmed: extended for paper record OCR with same API contract)
- ADR-009 object storage (confirmed: extended for scanned paper records)
- Architecture overview (needed Migration Service section)

**Items added/updated:**
- [ADR-008](adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration) created — score-based dedup algorithm
- [ADR-010](adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback) created — batch import with rollback
- [Tech Design: Migration Pipeline](tech-design-migration-pipeline.md) created — schema mapping, dedup engine, merge operations, batch processing, rollback
- Data model: `migration_batches`, `migration_records`, `duplicate_candidates` tables added
- Data model: migration fields added to `patients` and clinical tables
- API spec: Section 9 (Migration) added with batch, import, dedup, and rollback endpoints
- Architecture overview: Migration Service section added
- OCR service: `POST /ocr/patient-record` endpoint added for paper records
- Diagram: [Riverside Migration Pipeline](diagrams.md#riverside-migration-pipeline) added
- Test cases TC-1001 through TC-1011 added

**Result:** Full migration pipeline with batch rollback safety net. No auto-merge (all duplicates require staff review). Paper and electronic records converge at the validation stage for a single review workflow.

**Assessed by:** Alex Kim (Tech Lead), Priya Patel (Senior Engineer), Chen Wei (QA Lead)

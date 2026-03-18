# Architecture Decision Records

---

## ADR-001: WebSocket with Polling Fallback for Real-Time Dashboard Updates

**Date:** Round 1 (initial), Revised Round 2 (BUG-001)

**Status:** Accepted
**Last reviewed:** 2024-12-15 — confirmed after Round 9 scaling changes (WebSocket efficiency changes in ADR-007 are additive, ack mechanism unchanged)

**Triggered by:** [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen), [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data)
**Verified by:** [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [TC-202](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-203](../quality/test-suites.md#tc-203-sync-failure--dashboard-retry), [TC-204](../quality/test-suites.md#tc-204-dashboard-real-time-update--websocket-push)
**Monitored by:** [Sync Failure Rate, WebSocket Connections](../operations/monitoring-alerting.md#4-check-in-flow-dashboard)
**Confirmed by:** Alex Kim (Tech Lead), 2024-10-18

**Context:**
The receptionist dashboard must update in real-time when a patient checks in at the kiosk. In Round 1, we implemented WebSocket push from the server to the dashboard. In Round 2, we discovered that the kiosk was showing a green checkmark to the patient without confirming that the receptionist dashboard had actually received the data (BUG-001). The receptionist saw nothing; the patient thought they were done.

The root cause was twofold:
1. No acknowledgment mechanism — the system assumed WebSocket delivery was reliable
2. No fallback — if the WebSocket connection dropped, updates were silently lost

**Options Considered:**

1. **WebSocket only, with retry** — Retry failed WebSocket pushes. Simple, but doesn't handle disconnected clients.
2. **WebSocket with acknowledgment + polling fallback** — Dashboard acks each push via WebSocket. If WebSocket is disconnected, dashboard falls back to polling. Kiosk waits for ack before showing green checkmark.
3. **Server-Sent Events (SSE)** — Simpler than WebSocket, server-to-client only. But we also need client-to-server ack, so SSE alone is insufficient.
4. **Pure polling** — Dashboard polls every N seconds. Simple but introduces latency and doesn't scale well during peak.

**Decision:** Option 2 — WebSocket with ack + polling fallback.

**Implementation:**
- Receptionist dashboard connects via WebSocket at `/ws/dashboard/{location_id}`
- Server pushes check-in updates as they occur
- Dashboard sends an ack message back through the WebSocket for each update received
- The Check-In Service waits up to 5 seconds for the ack before responding to the kiosk
- If ack received within 5s: kiosk shows green checkmark
- If ack not received within 5s: kiosk shows yellow warning ("saved but front desk wasn't notified")
- If WebSocket disconnects: dashboard automatically falls back to polling `GET /dashboard/queue` every 5 seconds, with exponential backoff on reconnection attempts
- Server sends heartbeat ping every 30s; if no pong within 10s, connection is considered dead

**Consequences:**
- (+) End-to-end sync confirmation eliminates false green checkmarks (BUG-001 fix)
- (+) Polling fallback means updates are never silently lost
- (+) Ack mechanism enables the kiosk to give honest feedback to the patient
- (-) More complex than pure WebSocket or pure polling
- (-) The 5-second wait on kiosk confirmation adds perceived latency (but honest > fast)

---

## ADR-002: Session Purge Protocol for Kiosk State Isolation

**Date:** Round 4 (BUG-002 — P0 Security)

**Status:** Accepted
**Last reviewed:** 2024-12-20 — still valid, confirmed during Round 10 import work (migrated patient first-visit flow goes through same session purge)

**Triggered by:** [BUG-002](../product/user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan), [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan)
**Verified by:** [TC-301](../quality/test-suites.md#tc-301-sequential-patients--no-data-leakage), [TC-302](../quality/test-suites.md#tc-302-rapid-sequential-scans--no-data-leakage), [TC-303](../quality/test-suites.md#tc-303-rapid-sequential-scans--sub-second-timing), [TC-304](../quality/test-suites.md#tc-304-session-purge--dom-inspection), [TC-305](../quality/test-suites.md#tc-305-browser-back-button-does-not-reveal-previous-session)
**Monitored by:** [Data Leak Detected alert (P0)](../operations/monitoring-alerting.md#p0----page-immediately-any-time)
**Confirmed by:** Priya Patel (Senior Engineer), 2024-11-05

**Context:**
A patient scanned their card and briefly saw another patient's name and allergies on the kiosk screen. Root cause: the React component tree retained state from the previous patient's session. When the new patient's card was scanned, the app fetched new data but the old data remained visible in the DOM for a fraction of a second during the re-render cycle.

This is a PHI exposure — HIPAA-reportable. Trust in the kiosk is existential for the product.

**Options Considered:**

1. **Fix the React state management** — Ensure components properly clear state on new patient. Risk: React lifecycle edge cases are subtle; another code path could reintroduce the bug.
2. **Full DOM destruction + rebuild between sessions** — Unmount the entire React app, clear the DOM, reinitialize. Heavy but deterministic.
3. **Transition screen barrier** — Render a branded loading screen between sessions. The loading screen IS the proof that the old DOM is gone. Combined with a state reset.

**Decision:** Option 3, combined with elements of Option 2.

**Implementation — Session Purge Protocol:**
1. When a new card scan event fires (or the auto-return timer expires):
   a. Immediately unmount the patient data component tree
   b. Clear all React state, context, and memoized values
   c. Flush any in-memory caches (patient data, API responses)
   d. Cancel any in-flight API requests from the previous session
   e. Render the Session Transition Screen (branded loading screen)
2. Session Transition Screen displays for a minimum of 800ms
3. Only after the transition screen is rendered do we begin fetching the new patient's data
4. The transition screen fades into the identity confirmation screen when data arrives

**Why 800ms minimum?** This is not arbitrary. It's enough time to guarantee that:
- The DOM has fully re-rendered (no stale virtual DOM diffing artifacts)
- Any async state cleanup callbacks have completed
- The user sees a clean visual break between sessions

**Why not just fix the state management?** Because state management bugs can be reintroduced. The transition screen is a **defense-in-depth** design decision — even if a future developer introduces a state cleanup bug, the patient never sees stale data because the branded loading screen is always between sessions. Design (DD-001) correctly identified this as a designed safety net, not just a tech fix.

**Consequences:**
- (+) Deterministic isolation between patient sessions
- (+) Defense in depth — design layer protects against code-layer regressions
- (+) The transition screen also doubles as a natural loading state
- (-) Adds ~1 second to every check-in initiation
- (-) Requires discipline: every code path that changes patient context must go through this protocol

**Verification:**
- Automated test: rapid sequential card scans (< 500ms apart) must never render Patient A's data during Patient B's session
- The test runs in a headless browser simulating real DOM rendering, not just unit-testing React state

---

## ADR-003: Optimistic Concurrency Control via Version Field

**Date:** Round 7 (BUG-003)

**Status:** Accepted
**Last reviewed:** 2024-12-20 — still valid, confirmed during Round 10 (migration merge writes use same version mechanism)

**Triggered by:** [BUG-003](../product/user-stories.md#bug-003-concurrent-edit-causes-silent-data-loss), [US-004](../product/user-stories.md#us-004-concurrent-edit-safety-for-patient-records)
**Verified by:** [TC-701](../quality/test-suites.md#tc-701-two-receptionists--conflict-detection), [TC-702](../quality/test-suites.md#tc-702-conflict-resolution--view-current-version), [TC-703](../quality/test-suites.md#tc-703-conflict-resolution--re-apply-my-changes), [TC-704](../quality/test-suites.md#tc-704-no-conflict--normal-save), [TC-705](../quality/test-suites.md#tc-705-concurrent-edit--same-field-by-two-users), [TC-1201](../quality/test-suites.md#tc-1201-patch-patientsid--version-required)
**Monitored by:** [Version Conflicts Today](../operations/monitoring-alerting.md#4-check-in-flow-dashboard)
**Confirmed by:** Alex Kim (Tech Lead), 2024-11-25

**Context:**
Two receptionists simultaneously edited the same patient record (Mrs. Rodriguez). Receptionist A updated insurance from Aetna to Blue Cross and saved. Receptionist B, who had opened the record before A's save, updated the phone number and saved. B's save silently overwrote A's insurance change because the last write won — A's insurance update was lost.

PM decision DEC-003 chose optimistic locking over pessimistic locking or real-time collaborative editing.

**Options Considered:**

1. **Pessimistic locking (SELECT FOR UPDATE)** — Lock the record when opened for editing. Others see "record locked by X." Problem: in a clinic during peak hours, locking a record while someone walks away from their desk creates operational friction.
2. **Optimistic locking with version field** — Add a `version` integer to the patient record. Every update increments it. On save, `UPDATE ... WHERE version = expected_version`. If zero rows affected, conflict.
3. **Field-level conflict detection** — Track versions per field, not per record. Allow non-conflicting concurrent edits (A edits insurance, B edits phone = both succeed). More complex, fewer false conflicts.
4. **CRDT / operational transforms** — Real-time conflict-free data types. Massive over-engineering for a clinic receptionist tool.

**Decision:** Option 2 — record-level optimistic locking with version field.

**Why not field-level (Option 3)?** Field-level conflict detection is elegant but adds significant complexity to the API, the database schema, and the client. The frequency of concurrent edits on the same patient is low (two receptionists editing the same patient at the same time is an edge case, not the norm). Record-level locking occasionally produces false positives (A edits field X, B edits field Y = conflict even though the fields don't overlap), but the resolution flow is fast: review what changed, re-apply your edit. The cost of false positives is a few seconds of staff time in a rare scenario. The cost of field-level complexity is permanent architectural weight.

**Implementation:**

**Database:**
```sql
ALTER TABLE patients ADD COLUMN version INTEGER NOT NULL DEFAULT 1;
```

**On every write:**
```sql
UPDATE patients
SET phone = $new_phone, version = version + 1, updated_at = NOW()
WHERE id = $patient_id AND version = $expected_version;
-- If 0 rows affected → conflict
```

**On conflict detection:**
1. Fetch the current record (latest version)
2. Diff against the version the user loaded
3. Return 409 with `conflicting_changes`: who changed what, when
4. Client renders conflict banner (Design spec 2.2)
5. User chooses "View current version" (discard their edits) or "Re-apply my changes" (see their edits as a diff on top of the latest version)

**Version history:**
Every version change writes a row to `patient_record_versions` with a full snapshot and change summary. This supports:
- Conflict resolution UI (showing what changed between versions)
- Audit trail (who changed what, when)
- Potential rollback (not implemented yet, but the data is there)

**Consequences:**
- (+) No silent data loss — every conflict is surfaced
- (+) No locking delays during peak hours
- (+) Simple implementation — one integer field, one WHERE clause
- (+) Version history provides built-in audit trail
- (-) False positive conflicts when two users edit different fields of the same record
- (-) Client must handle 409 responses and render conflict resolution UI

---

## ADR-004: Immutable Medication Confirmation Audit Records

**Date:** Round 6 (E6: Compliance)

**Status:** Accepted
**Last reviewed:** 2024-12-15 — still valid

**Triggered by:** [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in), Epic [E6](../product/epics.md#e6-compliance--medication-list-at-check-in)
**Verified by:** [TC-601](../quality/test-suites.md#tc-601-medication-step-is-mandatory--cannot-skip), [TC-602](../quality/test-suites.md#tc-602-medication-confirmation--confirmed-unchanged), [TC-603](../quality/test-suites.md#tc-603-medication-confirmation--modified), [TC-604](../quality/test-suites.md#tc-604-medication-confirmation--confirmed-none), [TC-605](../quality/test-suites.md#tc-605-medication-confirmation--immutability), [TC-1202](../quality/test-suites.md#tc-1202-post-checkinsidcomplete--medication-confirmation-required)
**Confirmed by:** Chen Wei (QA Lead), 2024-11-15

**Context:**
State health board requires medication list confirmation at every visit. The confirmation must be auditable for license renewal inspection. This means we need a record of what the patient confirmed, when, and what the medication list looked like at that moment.

**Options Considered:**

1. **Timestamp on the medications table** — Add `last_confirmed_at` to each medication row. Problem: if the medication list changes after confirmation, the timestamp is still on the old rows but the current list is different. An auditor can't see what was actually confirmed.
2. **Separate confirmation table with foreign keys** — A `medication_confirmations` table that references medication IDs. Problem: if medications are edited or deleted after confirmation, the foreign keys point to changed data.
3. **Separate confirmation table with snapshots** — A `medication_confirmations` table that stores a frozen JSON snapshot of the medication list at confirmation time, plus metadata (confirmation type, channel, timestamp).

**Decision:** Option 3 — immutable confirmation records with medication snapshots.

**Implementation:**

```sql
CREATE TABLE medication_confirmations (
    id                  UUID PRIMARY KEY,
    patient_id          UUID NOT NULL REFERENCES patients(id),
    check_in_id         UUID NOT NULL REFERENCES check_ins(id),
    confirmation_type   VARCHAR(30) NOT NULL,  -- 'confirmed_unchanged', 'modified', 'confirmed_none'
    medication_snapshot JSONB NOT NULL,
    confirmed_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    channel             VARCHAR(20) NOT NULL
);
```

**Snapshot format:**
```json
[
  { "name": "Lisinopril", "dosage": "10mg", "frequency": "once_daily" },
  { "name": "Metformin", "dosage": "500mg", "frequency": "twice_daily" }
]
```

**Rules:**
- This table is INSERT-only. No UPDATEs, no DELETEs. Application-level and database-level (we can add a trigger to block updates if needed).
- One row is created per check-in that reaches the medication confirmation step.
- The snapshot is the medication list as it existed at the moment of confirmation, regardless of any subsequent changes.
- `confirmation_type` captures what the patient did: confirmed unchanged (one-tap), modified (added/removed/edited), or confirmed none (explicitly stated no medications).

**Why snapshots instead of references?** Because an auditor needs to see exactly what the patient confirmed at 9:17 AM on March 17. If we stored references and a medication was later edited, the auditor would see the current state, not the confirmed state. The snapshot is the source of truth for compliance.

**Consequences:**
- (+) Auditors can see exactly what was confirmed at any point in time
- (+) Immutable — no accidental or malicious modification of audit records
- (+) Decoupled from the mutable medications table
- (-) Data duplication (medication data exists in both tables)
- (-) Snapshots grow over time (mitigated: each snapshot is small, ~1KB typical)

---

## ADR-005: Centralized Database for Multi-Location (No Replication)

**Date:** Round 5 (E3: Multi-Location)

**Status:** Accepted
**Last reviewed:** 2024-12-15 — still valid, read replicas added in Round 9 are additive to centralized model

**Triggered by:** [US-009](../product/user-stories.md#us-009-cross-location-patient-record-access), [US-010](../product/user-stories.md#us-010-location-aware-check-in), Epic [E3](../product/epics.md#e3-multi-location-support)
**Verified by:** [TC-501](../quality/test-suites.md#tc-501-cross-location-patient-record--data-consistency), [TC-502](../quality/test-suites.md#tc-502-location-aware-kiosk), [TC-503](../quality/test-suites.md#tc-503-receptionist--location-filter-and-search), [TC-504](../quality/test-suites.md#tc-504-mobile-check-in--location-displayed)
**Confirmed by:** Priya Patel (Senior Engineer), 2024-11-10

**Context:**
The clinic is opening a second location. Patients may visit both. The patient record must be the same at every location. PM decision DEC-005 chose a centralized database over replication or event sourcing.

From an engineering perspective, the key question is: how do we model location as a dimension without making patient data location-specific?

**Decision:**

Location is a property of operational entities, not clinical entities:

| Entity | Location-scoped? | Rationale |
|--------|:---:|---|
| Patient | No | Patient data is universal |
| Allergies | No | Same person, same allergies |
| Medications | No | Same person, same medications |
| Insurance | No | Same person, same insurance |
| Appointment | Yes | Patient visits a specific location |
| Check-in | Yes | Check-in happens at a specific location |
| Kiosk | Yes | Physical device at a location |
| Staff assignment | Yes | Staff works at a location (can have multiple) |

**Implementation:**
- Add `location_id` FK to `appointments`, `check_ins`, `kiosks`
- Add `staff_locations` junction table
- Dashboard queries filter by `location_id` by default
- Search queries do NOT filter by location (cross-location search always)
- Mobile check-in link encodes the appointment's location for display

**Network dependency mitigation:**
All locations connect to the same cloud-hosted database. If connectivity is lost, the kiosk shows "temporarily unavailable." This is an acceptable degradation for 2-5 locations. Read replicas (added in Round 9) provide resilience for read-heavy dashboard queries.

**Consequences:**
- (+) Single source of truth — no sync conflicts
- (+) Simple data model — no location-specific copies
- (+) Patient data is immediately consistent across locations
- (-) Depends on network connectivity to central database
- (-) Would need re-architecture if offline capability becomes a requirement (not needed now)

---

## ADR-006: OCR Service as a Separate Service Behind a Stable API Contract

**Date:** Round 8 (E4: Insurance Card Photo Capture)

**Status:** Accepted
**Last reviewed:** 2024-12-20 — still valid, extended in Round 10 for paper record OCR (same contract, same service)

**Triggered by:** [US-011](../product/user-stories.md#us-011-photo-capture-of-insurance-card), Epic [E4](../product/epics.md#e4-insurance-card-photo-capture)
**Verified by:** [TC-801](../quality/test-suites.md#tc-801-photo-capture--happy-path-on-kiosk), [TC-802](../quality/test-suites.md#tc-802-photo-capture--ocr-failure), [TC-804](../quality/test-suites.md#tc-804-photo-capture-on-mobile), [TC-1009](../quality/test-suites.md#tc-1009-paper-record-ocr-pipeline)
**Monitored by:** [OCR Service Slow alert](../operations/monitoring-alerting.md#p2----investigate-during-next-business-day), [OCR Processing Time](../operations/monitoring-alerting.md#5-migration-dashboard-temporary----during-riverside-migration)
**Confirmed by:** Alex Kim (Tech Lead), 2024-12-05

**Context:**
Patients can photograph their insurance card. We need to extract structured fields (member ID, group number, payer name, etc.) from the photo. The OCR capability could be implemented via a third-party API (Google Vision, AWS Textract), a self-hosted model, or a hybrid.

**Decision:**

Wrap OCR behind a stable internal API contract. The OCR service is a separate service that:
1. Receives images (front and back of card)
2. Stores them in object storage (S3/MinIO)
3. Runs OCR extraction (implementation detail: currently Google Vision, but swappable)
4. Returns structured fields with per-field confidence scores

**API contract (internal):**

```
POST /ocr/insurance-card
Body: multipart (card_front, card_back)

Response:
{
  "fields": {
    "payer_name": { "value": "Blue Cross", "confidence": 0.99 },
    "member_id": { "value": "XYZ789", "confidence": 0.97 },
    ...
  },
  "front_image_key": "s3://...",
  "back_image_key": "s3://..."
}
```

The Check-In Service does not know or care whether OCR is powered by Google Vision, Textract, or a local model. The contract is stable.

**Why asynchronous?** OCR processing takes 3-5 seconds. The client (kiosk or mobile) submits photos, receives a `processing_id`, and polls for results. This keeps the HTTP connection lifecycle simple and handles slow OCR gracefully (the client shows "Reading your card..." and polls every second).

**Image storage:** Images are stored in S3/MinIO, not in the database. The patient record stores S3 keys (URLs) as references. Images are encrypted at rest.

**Consequences:**
- (+) OCR provider is swappable without changing the check-in service
- (+) Async processing handles variable OCR latency gracefully
- (+) Images in object storage, not bloating the database
- (-) Polling adds slight client complexity
- (-) An additional service to deploy and monitor

---

## ADR-007: Scaling Strategy for 50 Concurrent Sessions

**Date:** Round 9 (Performance)

**Status:** Accepted
**Last reviewed:** 2024-12-20 — current, validated against Round 10 migration load requirements

**Triggered by:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance)
**Verified by:** [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time), [TC-902](../quality/test-suites.md#tc-902-patient-search-performance-under-load), [TC-903](../quality/test-suites.md#tc-903-dashboard-stability-during-peak), [TC-904](../quality/test-suites.md#tc-904-degraded-mode--slow-backend), [TC-905](../quality/test-suites.md#tc-905-degraded-mode--backend-unreachable)
**Monitored by:** [p95 Response Time, Concurrent Sessions, DB Pool Utilization, Cache Hit Rate, Read Replica Lag](../operations/monitoring-alerting.md#p1----notify-during-business-hours)
**Confirmed by:** Priya Patel (Senior Engineer), 2024-12-15

**Context:**
Monday mornings between 8-9 AM, 30 patients check in simultaneously. Current system experiences kiosk freezes and slow search. Two patients left the clinic because of it. With a second location and mobile check-in, peak concurrency will grow. PM decision DEC-007 set the target at 50 concurrent sessions, p95 under 3 seconds.

**Root Cause Analysis:**

Profiling revealed three bottlenecks:
1. **Database connections** — Each check-in session held a DB connection for the duration of the multi-step flow. 30 concurrent sessions = 30 connections, exhausting the PostgreSQL `max_connections` default (100, shared with other services).
2. **Patient search** — `LIKE '%name%'` queries with no index. Full table scan on every keystroke (no debouncing on the client).
3. **Dashboard updates** — Each kiosk check-in triggered a full dashboard refresh for all connected receptionist clients via WebSocket broadcast.

**Decisions:**

### 1. Connection Pooling — PgBouncer

Deploy PgBouncer in transaction mode between the application server and PostgreSQL. Application connects to PgBouncer, which multiplexes connections.

- Pool size: 25 connections (for 50 concurrent sessions, not every session needs a connection simultaneously)
- Mode: transaction pooling (connection returned to pool after each transaction, not after session close)

### 2. Read Replicas

Add a PostgreSQL streaming replica for read-heavy queries:
- Dashboard queue queries → read replica
- Patient search → read replica
- Check-in writes → primary only
- Replication lag target: < 1 second

### 3. Query Caching (Redis)

Cache frequently-accessed, read-heavy data:
- Today's appointment queue per location (cache key: `queue:{location_id}:{date}`)
- Patient search results (cache key: `search:{query_hash}`, TTL: 30 seconds)
- Cache invalidation: write-through on patient record changes and check-in status changes

### 4. Search Optimization

- Composite index on `(last_name, first_name)` for exact prefix matching
- Trigram index (pg_trgm) for fuzzy matching
- Client-side debounce: 300ms after last keystroke before firing search
- Cancel in-flight search requests when new input arrives
- Minimum 2 characters before search fires

### 5. WebSocket Efficiency

- Scope WebSocket channels per location (`/ws/dashboard/{location_id}`)
- Push only the changed row, not the full queue — client updates its local state
- Batch rapid-fire updates (if 5 patients check in within 1 second, batch into a single push)

**Consequences:**
- (+) Projected to handle 50 concurrent sessions with p95 < 2 seconds (based on load testing with PgBouncer + read replica)
- (+) No architecture change — all optimizations are infrastructure and configuration
- (+) Incremental — each optimization can be deployed and measured independently
- (-) Operational complexity: PgBouncer, read replica, Redis all need monitoring
- (-) Cache invalidation bugs could show stale data on the dashboard (mitigated: short TTLs, write-through invalidation)

**Monitoring:**
| Metric | Target | Alert Threshold |
|--------|--------|----------------|
| p95 response time (all endpoints) | < 3s | > 2s (warning), > 3s (critical) |
| Concurrent sessions | < 50 | > 40 (warning) |
| DB connection pool utilization | < 80% | > 80% (warning) |
| Cache hit rate | > 70% | < 50% (investigate) |
| WebSocket connections | < 20 per location | > 15 (warning) |
| Read replica lag | < 1s | > 2s (critical) |

---

## ADR-008: Duplicate Detection Algorithm for Riverside Migration

**Date:** Round 10 (E5: Riverside Acquisition)

**Status:** Accepted
**Last reviewed:** 2024-12-22 — current (Round 10)

**Triggered by:** [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge), Epic [E5](../product/epics.md#e5-riverside-practice-acquisition)
**Verified by:** [TC-1003](../quality/test-suites.md#tc-1003-duplicate-detection--exact-match), [TC-1004](../quality/test-suites.md#tc-1004-duplicate-detection--no-match), [TC-1010](../quality/test-suites.md#tc-1010-duplicate-detection--near-miss-below-threshold), [TC-1011](../quality/test-suites.md#tc-1011-no-auto-merge-verification)
**Confirmed by:** Alex Kim (Tech Lead), 2024-12-20

**Context:**
We're importing 4,000 patient records from Riverside Family Practice. An estimated 5-15% overlap with our existing patients. We need to detect duplicates with high accuracy while minimizing both false positives (flagging non-duplicates) and false negatives (missing real duplicates). PM decision DEC-006: no auto-merge — all matches require staff confirmation.

**Algorithm:**

Score-based matching with multiple signals. Each match signal contributes a weighted score. Records exceeding a threshold are flagged as potential duplicates.

| Signal | Weight | Matching Logic |
|--------|--------|---------------|
| Full name + DOB exact match | 0.50 | Normalize names (lowercase, strip suffixes). Exact DOB match. |
| Last name + DOB match | 0.35 | First name may differ (nicknames, typos). |
| SSN last-4 match (if available) | 0.25 | Only ~40% of records have SSN. High-signal when present. |
| Phone number match | 0.20 | Normalize to digits only. Exact match. |
| Address match | 0.10 | Normalize street abbreviations. Fuzzy match on street name. |
| First name phonetic match | 0.10 | Soundex or Metaphone for nickname detection (Bob/Robert, Bill/William). |

**Scoring:**
- Score = sum of matching signal weights
- Threshold for flagging: 0.40 (catches name+DOB matches at minimum)
- Maximum possible score: 1.15 (all signals match, but capped at 1.0 for display)

**Example scores:**
- "Sarah Johnson, DOB 3/15/1982" + same phone → 0.50 + 0.20 = 0.70 → flagged
- "Sarah Johnson, DOB 3/15/1982" only → 0.50 → flagged
- Same phone only → 0.20 → not flagged (phone numbers can be reused)
- "S. Johnson, DOB 3/15/1982" (first name initial only) → 0.35 (last name + DOB) → not flagged, but close. Phonetic match on "S" vs "Sarah" does not fire (too short).

**Implementation:**

The algorithm runs as a batch process after each import:

```
For each imported Riverside record R:
    1. Query existing patients with same DOB (exact match — narrows the candidate set efficiently)
    2. For each candidate C:
        a. Calculate match score across all signals
        b. If score >= 0.40, create a duplicate_candidate record
    3. If no candidates exceed threshold, import R as a new patient
    4. If candidates found, flag R as "potential_duplicate" with the highest-scoring match
```

**Why DOB as the first filter?** DOB is indexed and has high cardinality. It reduces the candidate set from 10,000+ to typically < 10 before running the more expensive string comparisons. This keeps the batch import fast.

**Name normalization:**
- Lowercase
- Strip common suffixes (Jr., Sr., III)
- Strip middle names/initials for comparison
- Collapse whitespace
- Phonetic encoding for nickname detection (Soundex for simplicity, could upgrade to Double Metaphone)

**Consequences:**
- (+) High recall — the 0.40 threshold with name+DOB as the primary signal catches most real duplicates
- (+) Manageable false positive rate — estimated 2-5% of flagged records will be non-duplicates
- (+) Staff review handles all edge cases (PM requirement)
- (+) DOB-first filtering keeps batch processing fast (expected: < 5 minutes for 2,000 records against 10,000 existing)
- (-) Phonetic matching for nicknames is imperfect (won't catch all variations)
- (-) Missing SSN for ~60% of records reduces accuracy for those records
- (-) Algorithm tuning may be needed after the first batch — track staff override rate to calibrate

---

## ADR-009: Object Storage for Insurance Card Photos and Scanned Records

**Date:** Round 8 (E4: Insurance Card Photo Capture), extended Round 10 (E5: Paper Record Scanning)

**Status:** Accepted
**Last reviewed:** 2024-12-22 — current (Round 10)

**Triggered by:** [US-011](../product/user-stories.md#us-011-photo-capture-of-insurance-card), [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside)
**Verified by:** [TC-805](../quality/test-suites.md#tc-805-insurance-card-photos-stored-and-accessible-to-staff), [TC-1009](../quality/test-suites.md#tc-1009-paper-record-ocr-pipeline)
**Confirmed by:** Priya Patel (Senior Engineer), 2024-12-10

**Context:**
Two features require storing binary files:
1. Insurance card photos (front and back, captured by patient at kiosk or mobile)
2. Scanned paper records from Riverside migration

These are referenced from patient and migration records but should not live in the database.

**Decision:** Store all binary files in S3-compatible object storage (AWS S3 for cloud, MinIO for on-prem/dev). Database records store S3 keys as references.

**Storage structure:**
```
s3://clinic-checkin-files/
    insurance-cards/
        {patient_id}/
            {timestamp}-front.jpg
            {timestamp}-back.jpg
    scanned-records/
        {migration_batch_id}/
            {source_id}-page{n}.pdf
```

**Access control:**
- Files are not publicly accessible
- Access via presigned URLs generated by the Check-In Service (valid for 15 minutes)
- Staff accessing card photos: presigned URL generated on demand when they click the thumbnail
- Patient accessing their own photos during check-in: presigned URL generated as part of the check-in flow

**Encryption:**
- Server-side encryption (SSE-S3 or SSE-KMS)
- In transit: HTTPS only

**Retention:**
- Insurance card photos: retained indefinitely (staff may need to reference them)
- Scanned paper records: retained until migration is confirmed complete + 1 year regulatory hold

**Consequences:**
- (+) Database stays lean — no BLOBs
- (+) S3 handles durability, redundancy, and scaling automatically
- (+) Presigned URLs provide time-limited, auditable access without a proxy
- (-) Additional infrastructure to manage (S3 bucket policies, lifecycle rules)
- (-) Presigned URL expiry means cached images in the client will break after 15 minutes (acceptable — the client fetches a new URL on demand)

---

## ADR-010: Migration Pipeline Architecture — Batch Import with Rollback

**Date:** Round 10 (E5: Riverside Acquisition)

**Status:** Accepted
**Last reviewed:** 2024-12-22 — current (Round 10)

**Triggered by:** [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), Epic [E5](../product/epics.md#e5-riverside-practice-acquisition)
**Verified by:** [TC-1001](../quality/test-suites.md#tc-1001-emr-import--valid-records), [TC-1002](../quality/test-suites.md#tc-1002-emr-import--validation-failures), [TC-1007](../quality/test-suites.md#tc-1007-migration-rollback), [TC-1009](../quality/test-suites.md#tc-1009-paper-record-ocr-pipeline)
**Monitored by:** [Migration Import Errors alert](../operations/monitoring-alerting.md#p2----investigate-during-next-business-day)
**Confirmed by:** Alex Kim (Tech Lead), 2024-12-22

**Context:**
We need to import ~4,000 records from Riverside: ~2,000 electronic (from their EMR) and ~2,000 paper (scanned and OCR'd). The import must be reversible if systemic issues are found (e.g., schema mapping bug that corrupts data for an entire batch).

**Decision:**

The migration pipeline processes records in batches. Each batch is a transaction unit for rollback purposes.

**Pipeline stages:**

```
Source Data (Riverside EMR export / scanned paper)
    │
    ▼
Stage 1: Schema Mapping
    - Map Riverside fields to our data model
    - Normalize formats (dates, phone numbers, addresses)
    - Flag unmappable or missing fields
    │
    ▼
Stage 2: Validation
    - Check required fields (name, DOB at minimum)
    - Validate data types and formats
    - Records failing validation → status: "import_error"
    │
    ▼
Stage 3: Duplicate Detection
    - Run dedup algorithm (ADR-008) against existing patients
    - Records with matches → status: "potential_duplicate"
    - Records without matches → proceed to import
    │
    ▼
Stage 4: Import
    - Create patient record with migration_source set
    - Create associated allergies, medications, insurance records
    - Set patient_confirmed = FALSE (must be confirmed on first visit)
    - Record data_confidence scores (especially for OCR'd paper records)
    │
    ▼
Stage 5: Staff Review Queue
    - Import errors: staff corrects and re-submits
    - Potential duplicates: staff reviews side-by-side, decides merge/separate/flag
    - Low-confidence OCR: staff verifies fields manually
```

**Rollback mechanism:**

Each batch import is tracked via `migration_batches`. If a systemic issue is found:

1. `POST /migration/batches/{id}/rollback`
2. All patient records created by this batch are soft-deleted
3. All associated clinical records (allergies, medications, insurance) are soft-deleted
4. Duplicate resolutions are reversed (merged records are unmerged by restoring from `patient_record_versions`)
5. Batch status set to "rolled_back"
6. Migration records status set to "rolled_back"

**Paper record pipeline (OCR):**

```
Scanned PDF/image
    → Upload to object storage
    → Send to OCR service
    → OCR extracts fields with confidence scores
    → High confidence (> 0.85 per field): auto-populate mapped_data
    → Low confidence (< 0.85): flag field for manual review
    → Records flow into the same pipeline from Stage 2 onward
```

**Consequences:**
- (+) Batch rollback provides a safety net for systemic issues
- (+) Pipeline stages are modular — each can be debugged independently
- (+) Paper and electronic records converge at the validation stage — single review workflow
- (-) Rollback of merged records is complex (must restore from version history)
- (-) Large batch sizes (2,000 records) mean rollback is a heavy operation
- (-) OCR quality depends on paper record quality — some records may need full manual entry

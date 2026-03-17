# Decision Log

## DEC-001: BUG-002 elevated to P0, blocks all E1 feature work
**Date:** Round 4
**Context:** Patient saw another patient's name and allergies on screen after scanning their card. Brief but clearly visible. This is a PHI exposure — potential HIPAA breach.
**Options considered:**
1. Treat as P1 bug alongside other fixes
2. Treat as P0, halt E1 feature work until resolved
**Decision:** P0. Security and compliance trump features. We also need to evaluate whether HIPAA breach notification is required (consult legal).
**Rationale:** Even a transient display of another patient's data is a privacy violation. Trust is existential for a healthcare product. If patients can't trust the kiosk, nothing else matters.

---

## DEC-002: Medication confirmation is mandatory in the check-in flow, not optional
**Date:** Round 6
**Context:** State health board requires medication list confirmation at every visit for license renewal.
**Options considered:**
1. Add medications as an optional step patients can skip
2. Add medications as a mandatory step that blocks check-in completion
3. Add medications as a separate workflow outside check-in
**Decision:** Option 2 — mandatory step within check-in. Cannot be skipped.
**Rationale:** The regulation says "must collect and display... patient must confirm or update." Optional doesn't satisfy the mandate. Separate workflow risks patients skipping it entirely. Embedding it in the existing check-in flow is the smallest UX disruption while meeting the requirement. Trade-off: adds time to check-in. Mitigated by allowing "confirm unchanged" as a single action when the list hasn't changed.

---

## DEC-003: Optimistic concurrency control for patient records
**Date:** Round 7
**Context:** Two receptionists edited the same patient simultaneously. One update was silently lost.
**Options considered:**
1. Pessimistic locking — lock the record when one user opens it, block others
2. Optimistic locking — allow concurrent reads, detect conflicts on write
3. Real-time collaborative editing (Google Docs style)
**Decision:** Option 2 — optimistic locking with version check on save.
**Rationale:** Pessimistic locking would block staff during busy periods (exactly when concurrency is most likely). Real-time collab is overengineered for this — staff aren't co-editing a document, they're making discrete updates. Optimistic locking is the standard pattern: let both read, catch conflict on write, surface it clearly. The key requirement is "no silent data loss" — the user whose save is blocked must see what changed and be able to re-apply.

---

## DEC-004: Mobile check-in via mobile web, not native app
**Date:** Round 3
**Context:** Patient wants to check in from home before arriving.
**Options considered:**
1. Native iOS + Android apps
2. Mobile-optimized web flow (accessible via link)
3. SMS-based check-in (text responses)
**Decision:** Option 2 — mobile web.
**Rationale:** No app download friction. Patients get a link via SMS/email before their appointment and complete the flow in their browser. We don't need push notifications, background processing, or device APIs (except camera for insurance photo — web APIs support this). Native apps are a future consideration if adoption is high and we need deeper device integration. SMS-based is too limiting for the confirmation/edit flow we need.

---

## DEC-005: Centralized patient record for multi-location (not sync/replicate)
**Date:** Round 5
**Context:** Second location opening. Patients may visit both. Data must be the same at both.
**Options considered:**
1. Replicate patient data to each location's local database, sync periodically
2. Single centralized database, all locations connect to it
3. Event-sourced sync — changes propagate as events between location databases
**Decision:** Option 2 — centralized database.
**Rationale:** Replication introduces sync lag and conflict resolution complexity (we already have concurrency bugs — adding replication conflicts would compound the problem). Event sourcing is architecturally elegant but overkill for 2-5 locations. A centralized database is the simplest correct solution. Trade-off: locations depend on network connectivity to the central system. Mitigation: the system is already cloud-hosted; adding read replicas for resilience is an infrastructure concern, not an architecture change. Revisit if we scale to 20+ locations or need offline capability.

---

## DEC-006: Duplicate detection requires staff confirmation — no auto-merge
**Date:** Round 10
**Context:** Riverside acquisition will bring 4,000 patients, some of whom are already our patients. We need to deduplicate.
**Options considered:**
1. Auto-merge high-confidence matches (>95% match score)
2. All potential matches require staff confirmation
3. Auto-merge exact matches (SSN + DOB + name), staff review for fuzzy matches
**Decision:** Option 2 — all matches require staff confirmation.
**Rationale:** Merging the wrong patients is worse than having a temporary duplicate. In healthcare, a false merge can combine medication lists, allergy records, and visit histories of two different people — that's a safety risk. The volume is manageable (4,000 records, likely a few hundred potential duplicates). Staff review takes a few minutes per case. The cost of getting it wrong (patient safety, legal liability) far outweighs the cost of manual review. We'll surface matches ranked by confidence score so staff can process high-confidence ones quickly.

---

## DEC-007: Performance target — 50 concurrent sessions, p95 under 3 seconds
**Date:** Round 9
**Context:** Monday mornings, 30 simultaneous check-ins cause kiosk freezes and slow search. Patients are leaving.
**Options considered:**
1. Target current peak (30 concurrent) with 20% headroom = ~36
2. Target 50 concurrent (room for growth + second location)
3. Target 100 concurrent (aggressive future-proofing)
**Decision:** Target 50 concurrent sessions, p95 response time under 3 seconds.
**Rationale:** 30 is today's peak at one location. With a second location and mobile check-in, peaks will grow. 50 gives us comfortable headroom without over-engineering for a scale we don't have. 100 would drive infrastructure costs we can't justify yet. We'll add performance monitoring to track actual peaks and revisit the target if we consistently hit 40+.

---

## DEC-008: Riverside paper records — digitization pipeline, not bulk data entry
**Date:** Round 10
**Context:** Half of Riverside's 4,000 patient records are paper-only.
**Options considered:**
1. Hire temps for bulk manual data entry before go-live
2. Scan and OCR paper records, staff review extracted data
3. Enter paper records on demand — when a Riverside patient visits, digitize their record at check-in
**Decision:** Combination of 2 and 3. Scan all paper records upfront (OCR extraction), but allow on-demand completion for records that fail OCR or have low confidence.
**Rationale:** Bulk manual entry is expensive, error-prone, and delays the migration. Pure on-demand means the first visit for every paper-record patient is slow and painful. Scanning all records with OCR gives us a head start — high-confidence extractions go into the system ready for confirmation. Low-confidence or failed extractions are flagged and can be completed when the patient visits or by staff in batches. This balances speed, cost, and data quality.

# Reconciliation Log

Running record of change events that triggered impact assessment and re-verification of PM inventory items.

---

## REC-001: BUG-001 Sync Failure — Kiosk Confirmation Not Reaching Receptionist

**Date:** 2024-02-01
**Change/trigger:** Round 2 — patient completed kiosk check-in (green checkmark displayed) but receptionist screen showed nothing. Staff had to fall back to paper forms.
**Assessed by:** Sarah Chen (PM Lead), Chen Wei (QA Lead)

**Impact assessment:**
- Core check-in value proposition broken — kiosk is useless if staff can't see the data
- Root cause: no acknowledgment mechanism on WebSocket sync, kiosk showed success before confirming receptionist system received data
- Paper fallback negates the entire purpose of the kiosk system

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| US-002 | Created — receptionist sees confirmed check-in data | Story scoped with 4 AC including end-to-end sync verification, not just patient-facing confirmation. |
| BUG-001 | Created — P1 bug story with 4 AC | Requires end-to-end verification: kiosk confirm -> receptionist sees data. False green checkmark must not recur. |
| ADR-001 | Created — WebSocket with polling fallback + ack verification | Polling fallback ensures sync even if WebSocket drops. Ack mechanism prevents premature success display. |
| E1 traceability | Updated — added US-002, BUG-001, ADR-001 references | Epic trace table now reflects sync failure scope. |
| Backlog | Re-prioritized — BUG-001 added at P1 | Core flow broken — must fix before expanding features. |

---

## REC-002: BUG-002 Security Incident — Session Data Leak

**Date:** 2024-02-15
**Change/trigger:** Round 4 — patient saw another patient's name and allergies briefly on kiosk after scanning their card. PHI exposure reported.
**Assessed by:** Sarah Chen (PM Lead), Dr. Martinez (Medical Director)

**Impact assessment:**
- P0 security incident — potential HIPAA breach notification required
- All E1 feature work blocked until resolved (DEC-001)
- Patient trust in kiosk is existential — this undermines the entire check-in value proposition

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| US-001 | Reviewed — does pre-population flow clear previous session? | Gap found: no explicit session purge between patients. AC updated to require session isolation. |
| US-003 | Created — new story for secure patient identification | New story scoped with 5 AC including audit log and security testing requirements. |
| BUG-002 | Created — P0 bug story with 6 AC | Includes DOM purge, penetration test, and HIPAA breach notification AC. |
| DEC-001 | Created — decision to elevate to P0, block E1 features | Ratified by Medical Director same day. |
| E1 traceability | Updated — added BUG-002, US-003, DEC-001, ADR-002 references | Epic trace table now reflects security incident scope. |
| Backlog | Re-prioritized — BUG-002 moved to top of backlog as P0 | All other E1 work deprioritized until resolved. |

---

## REC-003: State Medication Mandate

**Date:** 2024-03-01
**Change/trigger:** Round 6 — state health board mandate requiring medication list confirmation at every patient visit, effective Q3. Non-compliance risks clinic license revocation.
**Assessed by:** Dr. Martinez (Medical Director), Sarah Chen (PM Lead)

**Impact assessment:**
- External regulatory source — mandatory, non-negotiable
- Hard deadline: must be live before Q3 license renewal period
- Affects every check-in channel: kiosk, receptionist, mobile (E2 dependency)
- Requires immutable audit records for inspection

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E1 scope | Reviewed — medication confirmation must be added to check-in flow | Added compliance impact section to E1 epic. |
| US-005 | Created — mandatory medication list confirmation story | 6 AC including audit immutability, every-visit confirmation, and "no medications" explicit confirmation. |
| E6 | Created — new epic for compliance scope | Dedicated epic with hard Q3 deadline, traces to US-005, DEC-002, ADR-004. |
| DEC-002 | Created — mandatory in flow, not optional | Options evaluated: optional step vs. mandatory vs. separate workflow. Mandatory won — regulation requires it. |
| US-007 (E2) | Reviewed — mobile flow must include medication step | Confirmed: mobile check-in must include medications. Added to E2 dependencies. |
| PRD: Mobile Check-In | Updated — added E6 dependency | Medication confirmation is required at mobile launch, not a follow-up. |
| Backlog | Re-prioritized — US-005 moved to P1 with design kickoff this sprint | Q3 deadline requires lead time for design + implementation. |

---

## REC-004: BUG-003 Concurrent Edit Data Loss

**Date:** 2024-03-10
**Change/trigger:** Round 7 — two receptionists edited the same patient record (Mrs. Rodriguez). One receptionist's insurance update was silently lost. No error, no warning — data simply disappeared.
**Assessed by:** Sarah Chen (PM Lead), Alex Kim (Engineering)

**Impact assessment:**
- Silent data loss is a patient safety and billing risk — insurance details drive claim submission
- No concurrency control exists on patient record writes
- Problem will worsen with multi-location (E3) — more staff editing shared records

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| US-004 | Created — concurrent edit safety story | 5 AC including optimistic locking, conflict notice with diff, and no-silent-overwrite guarantee. |
| BUG-003 | Created — P1 bug story with 5 AC | Requires version check on save, conflict UI, and re-apply workflow. |
| DEC-003 | Created — optimistic concurrency control for patient records | Evaluated pessimistic locking vs. optimistic vs. CRDT. Optimistic chosen — simplest correct solution for this access pattern. |
| ADR-003 | Created — optimistic concurrency control via version field | Version field on patient record, 409 on conflict, client-side conflict resolution UI. |
| E1 traceability | Updated — added US-004, BUG-003, DEC-003, ADR-003 references | Epic trace table now reflects concurrency scope. |
| Backlog | Re-prioritized — BUG-003 added at P1 alongside BUG-001 | Both are data integrity issues in the core flow. |

---

## REC-005: Insurance Card Photo Capture

**Date:** 2024-03-15
**Change/trigger:** Round 8 — patient frustrated trying to read tiny numbers off a new insurance card at the kiosk. Requested photo capture instead of manual entry.
**Assessed by:** Sarah Chen (PM Lead), Alex Kim (Engineering)

**Impact assessment:**
- High-friction pain point in the check-in flow — insurance entry is the slowest step
- Camera hardware already available on kiosks and patient mobile devices
- OCR introduces a new external service dependency (ADR-006)
- Must work on both kiosk and mobile (E2 dependency)

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E4 | Created — Insurance Card Photo Capture epic | Scope: camera capture on kiosk and mobile, OCR extraction, patient review, staff access to stored images. |
| US-011 | Created — photo capture of insurance card story | 7 AC covering capture, OCR extraction, patient review, low-confidence highlighting, and manual fallback. |
| ADR-006 | Created — OCR as a separate service behind a stable API contract | Decouples OCR vendor choice from check-in flow. Allows swap without UI changes. |
| ADR-009 | Created — object storage for insurance card photos | Photos stored in object storage with presigned URLs for staff access. |
| E2 (Mobile) | Reviewed — mobile check-in must include photo capture option | Confirmed: photo capture added to mobile insurance review screen spec. |
| Backlog | Updated — US-011 added at P3 | Nice acceleration for mobile launch but not blocking. |

---

## REC-006: Monday Morning Performance Crisis

**Date:** 2024-03-28
**Change/trigger:** Round 9 — operational signal from clinic staff. Monday mornings between 8-9 AM, 30+ simultaneous check-ins causing kiosk freezes and slow patient search. Two patients left the clinic this month.
**Assessed by:** Alex Kim (Engineering), Sarah Chen (PM Lead)

**Impact assessment:**
- Direct revenue impact — patients walking out
- Current architecture cannot handle actual peak load
- Second location (E3) will compound the problem — peaks will grow to 50+
- Performance must be addressed before E3 launch or Location B will fail on day one

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| US-006 | Created — peak-hour performance story | 5 AC with specific targets: 50 concurrent sessions, p95 < 3s, degraded-mode handling. |
| DEC-007 | Created — performance target decision | Evaluated 36 vs. 50 vs. 100 concurrent target. 50 chosen — headroom for second location without over-engineering. |
| E1 traceability | Updated — added US-006, DEC-007, ADR-007 references | Performance is now tracked as part of E1 scope. |
| US-009, US-010 (E3) | Reviewed — multi-location launch depends on performance fix | Confirmed: E3 should not go live until US-006 is proven. Added performance as implicit dependency. |
| PRD: Multi-Location | Reviewed — technical considerations section | Updated to reference US-006 and DEC-007 for performance planning. |
| Backlog | Reprioritized — US-006 moved to P2, sequenced before E3 launch | Performance fix unblocks second location opening. |

---

## REC-007: Riverside Practice Acquisition

**Date:** 2024-04-05
**Change/trigger:** Round 10 — business decision to acquire Riverside Family Practice. 4,000 patient records (half electronic, half paper), different EMR system, unknown patient overlap with existing base.
**Assessed by:** Sarah Chen (PM Lead), Dr. Martinez (Medical Director), Chen Wei (QA Lead)

**Impact assessment:**
- Largest scope expansion since project start — new epic (E5), new PRD, 2 new stories, 2 new decisions, 3 new ADRs
- Patient safety risk: false merges could combine medication lists of different people
- E3 (multi-location) is a hard prerequisite — Riverside locations must be added to existing infrastructure
- Paper record digitization is a long-tail effort — will outlast the migration sprint

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E5 | Created — Riverside Practice Acquisition epic | Full scope: EMR migration, paper digitization, duplicate detection, post-migration verification. |
| US-012 | Created — patient data migration story | 4 AC covering electronic import, paper digitization pipeline, validation, and migration reporting. |
| US-013 | Created — duplicate detection and merge story | 6 AC including no-auto-merge, field-level merge, confidence scoring, and audit trail preservation. |
| DEC-006 | Created — no auto-merge decision | Patient safety risk of false merge outweighs convenience of automation. All matches require staff confirmation. |
| DEC-008 | Created — digitization pipeline decision | Hybrid approach: OCR all paper records upfront, on-demand completion for failures. Balances speed and quality. |
| PRD: Riverside Acquisition | Created — full PRD with 3 phases | Phase 1: electronic import, Phase 2: paper digitization, Phase 3: verification and go-live. |
| E3 (Multi-Location) | Reviewed — Riverside locations are new E3 consumers | Confirmed E3 is prerequisite. Added E5 dependency note to E3 epic. |
| US-005 (E6) | Reviewed — migrated medication data must conform to confirmation model | Confirmed: Riverside medication data must map to our schema including frequency codes. Gap identified (BID -> twice_daily mapping). |
| Backlog | Updated — US-012, US-013 added at P3 | Sequenced after E3 is in place. PRD needs sign-off before engineering starts. |

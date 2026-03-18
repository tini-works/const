# Reconciliation Log — QA Vertical

Tracks how QA inventory was reevaluated and updated in response to changes from other verticals (bugs, architecture decisions, new features). Each entry records the trigger, impact assessment, items reevaluated, items added, and result.

---

## Entry 1: BUG-001 Sync Failure — Kiosk-to-Receptionist (Round 2)

**Date:** 2024-01-20
**Change:** P1 sync bug — kiosk showed green checkmark but receptionist dashboard received nothing. ADR-001 (WebSocket with Polling Fallback) introduced dual-channel sync with confirmation receipt.
**Impact:** Suite 1 (Core Kiosk) tested check-in flow end-to-end but did not verify receptionist-side receipt or handle sync failure/timeout scenarios.

**Items reevaluated:**
- Suite 1 (Core Kiosk): reviewed TC-101 through TC-107 — confirmation step assumed sync was instant and reliable, no failure path tested
- test-plan.md: sync verification added as a Critical priority area
- coverage-report.md: US-002 row had no test cases mapped

**Items added:**
- Suite 2 (Sync): TC-201 through TC-204 — successful sync with green checkmark, sync timeout with yellow warning, sync failure with dashboard retry, real-time WebSocket push update
- coverage-report.md: US-002 mapped to TC-201..204; BUG-001 row added to Bug Fixes section

**Result:** Kiosk-to-receptionist sync covered by 4 test cases with CI gate enforcement. 20-checkin regression added. WebSocket and polling fallback both verified.
**Assessed by:** Li Zhang (QA Engineer)

---

## Entry 2: US-007 Mobile Check-In (Round 3)

**Date:** 2024-02-01
**Change:** US-007 (Pre-visit mobile check-in) introduced mobile channel — patients complete check-in from personal device before arriving. US-008 (Receptionist visibility of mobile check-ins) required dashboard to show mobile channel.
**Impact:** No mobile test coverage existed. All prior suites assumed kiosk-only interaction. Dashboard tests (Suite 2) did not distinguish check-in channel.

**Items reevaluated:**
- Suite 2 (Sync): reviewed TC-201..204 — sync tests needed to account for mobile-originated check-ins appearing on dashboard with channel indicator
- Suite 1 (Core Kiosk): reviewed for duplicate prevention if patient checks in on mobile then arrives at kiosk
- coverage-report.md: US-007 and US-008 rows had no test cases mapped

**Items added:**
- Suite 4 (Mobile): TC-401 through TC-407 — happy path, identity verification failure, expired link, partial completion and resume, duplicate prevention (mobile then kiosk), session timeout, already checked in via mobile
- coverage-report.md: US-007 mapped to TC-401..407; US-008 mapped to TC-201, TC-401, TC-404

**Coverage gaps identified:**
- SMS/email link delivery not tested (depends on Twilio sandbox)
- Cross-browser compatibility on iOS Safari and Chrome Android not tested

**Result:** Mobile check-in covered by 7 test cases spanning happy path, error handling, partial completion, and duplicate prevention. Two gaps tracked in backlog.
**Assessed by:** Chen Wei (QA Lead)

---

## Entry 3: BUG-002 Security Incident — Session Isolation (Round 4)

**Date:** 2024-02-15
**Change:** P0 security incident — previous patient's PHI visible on kiosk between sessions. ADR-002 (Session Purge Protocol) introduced three-layer defense-in-depth.
**Impact:** Existing test suites had no session isolation tests. Suite 1 (Core Kiosk) assumed single-patient-at-a-time with clean slate — no adversarial or rapid-scan scenarios existed.

**Items reevaluated:**
- Suite 1 (Core Kiosk): reviewed TC-101 through TC-107 for implicit session isolation assumptions — determined they do not cover multi-patient transitions
- test-plan.md: priority and risk areas updated — session isolation elevated to Critical #1 gate
- coverage-report.md: Session Isolation section added under "Coverage by Feature Area"

**Items added:**
- Suite 3 (Session Isolation): TC-301 through TC-306 — sequential patients, rapid scans, sub-second timing, DOM inspection, browser back button, audit log
- test-plan.md entry criteria: added "session purge verification passes" as a release gate
- coverage-report.md: Data Leak Detected production monitor linked to all session isolation TCs

**Result:** Session isolation is now the highest-priority test area with 6 dedicated test cases, CI gate enforcement (TC-303, TC-304), and a P0 production monitor. No gaps remain in the critical path.
**Assessed by:** Chen Wei (QA Lead)

---

## Entry 4: BUG-003 Concurrent Edit — Optimistic Locking (Round 7)

**Date:** 2024-03-01
**Change:** P1 data integrity bug — two receptionists editing the same patient caused silent data loss. ADR-003 (Optimistic Concurrency Control via version field) introduced version-based locking on all mutable entities.
**Impact:** No concurrency tests existed. Suite 2 (Sync) tested kiosk-to-dashboard delivery but not concurrent dashboard edits. API contract tests did not enforce version requirement.

**Items reevaluated:**
- Suite 2 (Sync): confirmed TC-201 through TC-204 are unaffected — sync is write-once from kiosk, not concurrent edits
- coverage-report.md: US-004 row added to coverage matrix; API Contract section reviewed
- test-plan.md: Concurrent edit safety added to Critical priority #3

**Items added:**
- Suite 7 (Concurrent Edit Safety): TC-701 through TC-705 — conflict detection, "View current version", "Re-apply my changes", normal save, same-field conflict
- Suite 12 (API Contract): TC-1201 — PATCH /patients/{id} version required (400 without, 409 with wrong version)
- coverage-report.md: Version Conflicts Today production monitor linked

**Result:** Concurrent edit safety covered by 5 functional tests + 1 API contract test. 10-concurrent-edit stress test added to regression. Version requirement enforced at API layer.
**Assessed by:** Li Zhang (QA Engineer)

---

## Entry 5: Performance — Peak Load Testing (Round 9)

**Date:** 2024-03-05
**Change:** US-006 (Peak-hour check-in performance) required system to handle 50 concurrent sessions with p95 < 3s. ADR-007 (Scaling Strategy) introduced PgBouncer, read replicas, and Redis cache.
**Impact:** No load tests existed. All prior test suites ran sequentially with single-user assumptions. Dashboard stability under concurrent WebSocket connections was untested.

**Items reevaluated:**
- Suite 2 (Sync): TC-204 tested WebSocket push but only with single connection — inadequate for peak load
- Suite 4 (Mobile): TC-401 tested mobile check-in but not under concurrent load
- Suite 5 (Multi-Location): TC-501 through TC-504 tested cross-location but not under load
- coverage-report.md: US-006 row was empty — no test cases mapped

**Items added:**
- Suite 9 (Performance): TC-901 through TC-905 — 50 concurrent check-ins, search under load, dashboard stability, degraded mode (slow backend), degraded mode (unreachable backend)
- test-plan.md: "Performance test meets targets (50 concurrent, p95 < 3s)" added to exit criteria
- coverage-report.md: US-006 mapped to TC-901 through TC-905 with production monitors (p95 Response Time, Concurrent Sessions Warning, DB Pool Near Capacity)

**Coverage gaps identified:**
- Mobile-under-load not separately tested (mobile sessions included in TC-901 aggregate but no dedicated mobile load suite)
- WebSocket connection churn under repeated connect/disconnect not tested

**Result:** Performance covered by 5 test cases with dedicated load-test environment. Load test run manually by DevOps (James Park) before each release. Gaps tracked in backlog.
**Assessed by:** Chen Wei (QA Lead)

---

## Entry 6: Riverside Acquisition — Data Migration (Round 10)

**Date:** 2024-03-08
**Change:** Business acquisition of Riverside Family Practice. US-012 (data migration) and US-013 (duplicate detection/merge) introduced. ADR-008 (duplicate detection algorithm), ADR-010 (migration pipeline with rollback) added.
**Impact:** Entirely new feature area with no existing test coverage. Migration touches patient records — potential impact on session isolation (migrated patients checking in), concurrency (staff merging while receptionist edits), and compliance (migrated medication data).

**Items reevaluated:**
- Suite 1 (Core Kiosk): reviewed TC-101 — does the happy path work for a migrated patient with `patient_confirmed = FALSE`? Determined a new TC was needed.
- Suite 6 (Medication Compliance): reviewed TC-601 through TC-606 — does medication confirmation work for migrated medication data? Covered by existing TCs since medications are loaded the same way regardless of source.
- Suite 3 (Session Isolation): no impact — session purge is patient-source-agnostic.
- test-plan.md: Scope section expanded with migration entries; Data Migration test type added to strategy matrix.
- coverage-report.md: US-012 and US-013 rows added to coverage matrix; Data Migration section added.

**Items added:**
- Suite 10 (Migration): TC-1001 through TC-1011 — EMR import (valid/invalid), duplicate detection (exact/no-match/near-miss), staff merge review, keep separate, rollback, first-visit confirmation, paper record OCR, no-auto-merge verification
- test-plan.md: "Duplicate detection accuracy" added to High priority #8; test environments expanded with Pre-Prod (Multi-Location) and migration sandbox
- coverage-report.md: 3 new coverage gaps identified (batch processing flow, medication frequency mapping, progress dashboard live counts)

**Coverage gaps identified:**
- Batch sequential review flow (staff reviews 10 duplicates at a time) — no TC
- Riverside medication frequency mapping (BID -> twice_daily) — no TC
- Admin migration dashboard count accuracy during active import — no TC

**Result:** Migration covered by 11 test cases across import, dedup, merge, rollback, and first-visit flows. Run in dedicated migration sandbox by Lisa Nguyen. Three gaps tracked in backlog for follow-up.
**Assessed by:** Chen Wei (QA Lead)

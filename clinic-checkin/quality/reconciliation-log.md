# Reconciliation Log — QA Vertical

Tracks how QA inventory was reevaluated and updated in response to changes from other verticals (bugs, architecture decisions, new features). Each entry records the trigger, impact assessment, items reevaluated, items added, and result.

---

## Entry 1: BUG-002 Security Incident — Session Isolation (Round 4)

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

## Entry 2: BUG-003 Concurrent Edit — Optimistic Locking (Round 7)

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

## Entry 3: Performance — Peak Load Testing (Round 9)

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

## Entry 4: Riverside Acquisition — Data Migration (Round 10)

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

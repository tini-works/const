# Reconciliation Log — QA Vertical

Tracks how QA inventory was reevaluated and updated in response to changes from other verticals (bugs, architecture decisions, new features). Each entry records the trigger, impact assessment, items reevaluated, items added, and result.

---

## Entry 1: BUG-001 Multi-Commit Deploy — Atomic Model Introduced (Round 1)

**Date:** 2025-06-20
**Change:** P1 multi-commit deploy incident. Team Falcon's 3-commit deploy broke checkout. ADR-001 (Atomic Deploy Model) introduced one-commit-per-deploy enforcement.
**Impact:** No deploy test suite existed at all — this was the first round. Suite 1 was created from scratch to cover the atomic deploy model.

**Items reevaluated:**
- No prior test suites existed — this was the initial QA investment
- test-plan.md: created with deploy safety as the highest priority

**Items added:**
- Suite 1 (Core Deploy Safety): TC-101 through TC-104 — single-commit deploy, rollback, multi-commit rejection, build failure handling
- coverage-report.md: US-001 and US-002 mapped to TC-101..104
- bug-reports.md: BUG-001 documented with traceability

**Result:** Deploy safety covered by 4 initial test cases. Rollback verified under 2 minutes. Multi-commit rejection automated in CI.
**Assessed by:** Dani Reeves (QA Lead)

---

## Entry 2: BUG-002 Bypass Overwrite — Drift Detection Added (Round 2)

**Date:** 2025-07-01
**Change:** P0 incident — Sasha's weekend hotfix was silently overwritten by a Monday deploy. ADR-002 (Drift Detection via State Fingerprinting) introduced drift detection, resolution, and deploy blocking.
**Impact:** Suite 1 tested deploy and rollback but had no concept of "production state differs from expected state." All existing tests assumed Pave's view of production was accurate.

**Items reevaluated:**
- Suite 1 (Core Deploy Safety): reviewed TC-101 through TC-104 — none tested production state verification
- test-plan.md: bypass overwrite prevention added as Critical priority #2
- coverage-report.md: US-003 row had no test cases mapped

**Items added:**
- Suite 1 extended: TC-105 through TC-112 — drift detection (SSH mutation, clean state), drift resolution (accept, revert), deploy blocked on drift, bypass overwrite prevention, audit trail
- coverage-report.md: US-003 mapped to TC-105..110; BUG-002 row added; Core Deploy Safety section expanded with drift subsection
- test-plan.md: drift detection added to entry criteria

**Coverage gaps identified:**
- Drift detection for non-K8s workloads (Docker Compose) not tested — depends on E3 onboarding
- Drift detection for environment variable changes via ConfigMap — not tested

**Result:** Drift detection covered by 8 test cases. Deploy blocking verified. 3 incident drill scenarios passed. One gap tracked (non-K8s drift).
**Assessed by:** Dani Reeves (QA Lead)

---

## Entry 3: US-004/US-005 Canary Deploys — Progressive Rollout (Round 3)

**Date:** 2025-07-15
**Change:** US-004 (Canary with traffic splitting) and US-005 (Auto-rollback on threshold breach) introduced. ADR-003 (Canary Deploy via Weighted Traffic Splitting) added Istio-based traffic splitting with replica fallback.
**Impact:** No canary test coverage existed. Suite 1 tested full deploy and rollback. Canary introduced a new lifecycle: deploy partial → observe → promote or abort.

**Items reevaluated:**
- Suite 1 (Core Deploy Safety): reviewed TC-102 (rollback) — canary abort is a different rollback mechanism, needs separate coverage
- test-plan.md: canary auto-rollback added as High priority #5
- coverage-report.md: US-004 and US-005 rows had no test cases mapped

**Items added:**
- Suite 2 (Canary Deploys): TC-201 through TC-208 — traffic split, promote, abort, auto-rollback (error rate), auto-rollback (latency), custom percentage, metrics comparison, non-Istio fallback
- coverage-report.md: US-004 mapped to TC-201..203, TC-206..208; US-005 mapped to TC-204, TC-205; Canary Deploys section added

**Coverage gaps identified:**
- TC-208 (non-Istio canary fallback) not executable — ECS staging environment not provisioned
- Canary deploys on PCI-scoped services — does the approval gate fire before canary or before promote?

**Result:** Canary covered by 8 test cases (7 executed, 1 pending environment). Auto-rollback verified for both error rate and latency thresholds. Two gaps tracked.
**Assessed by:** Dani Reeves (QA Lead)

---

## Entry 4: US-006/US-007 Multi-Stack Onboarding — Gridline Acquisition (Round 4)

**Date:** 2025-08-05
**Change:** Gridline acquisition forced Pave to support non-K8s stacks. ADR-004 (pave.yaml schema) and ADR-005 (Adapter pattern) introduced. `pave init` and `pave validate` commands added.
**Impact:** All prior test suites assumed K8s runtime. Onboarding was not a tested workflow. Docker Compose deploys were untested.

**Items reevaluated:**
- Suite 1 (Core Deploy Safety): reviewed TC-101 — does single-commit enforcement work for Docker Compose deploys? Determined a separate TC was needed (TC-305)
- Suite 1, TC-105/TC-106 (drift detection): do fingerprints work for Docker Compose? Flagged as gap — drift detection is K8s-only
- coverage-report.md: US-006 and US-007 rows were empty

**Items added:**
- Suite 3 (Onboarding): TC-301 through TC-306 — pave.yaml validation (K8s, Docker Compose, invalid), pave init wizard, Docker Compose deploy, onboarding status tracking
- coverage-report.md: US-006 mapped to TC-302, TC-305; US-007 mapped to TC-301..304, TC-306
- test-plan.md: environments expanded with Docker Compose test environment

**Coverage gaps identified:**
- ECS adapter untested — only Docker Compose adapter verified
- Drift detection for Docker Compose workloads not covered
- TC-306 (onboarding status tracking) marked suspect after schema v2 migration

**Result:** Onboarding covered by 6 test cases (5 passing, 1 suspect). Docker Compose deploy path verified with Gridline's stack. ECS gap tracked.
**Assessed by:** Dani Reeves (QA Lead)

---

## Entry 5: US-008/US-009 RBAC & Audit — SOC2 Compliance (Round 5)

**Date:** 2025-08-20
**Change:** SOC2 audit found no RBAC. ADR-006 (RBAC model) and ADR-007 (immutable audit log) introduced. Every deploy action must be attributable. Intern deploys to prod must be blocked.
**Impact:** No RBAC tests existed. All prior test suites ran as a single user with full permissions. Audit trail verification was limited to TC-112 (basic deploy audit).

**Items reevaluated:**
- Suite 1, TC-112 (deploy audit trail): confirmed it covers basic audit — extended tests needed for role changes, RBAC violations
- All prior test suites: reviewed for implicit "any user can do this" assumptions — all TC preconditions now specify required role
- coverage-report.md: US-008 and US-009 rows were empty

**Items added:**
- Suite 4 (RBAC & Audit): TC-401 through TC-408 — authorized deploy, unauthorized (wrong role), unauthorized (wrong team), intern restrictions, role grant/revoke, audit log (deploy events, role changes, query/filter)
- coverage-report.md: US-008 mapped to TC-112, TC-406..408; US-009 mapped to TC-401..405
- test-plan.md: RBAC enforcement added to exit criteria

**Coverage gaps identified:**
- RBAC for bypass deploys (break-glass) — does `pave bypass` record the actor?
- Cross-environment role boundary with canary (deployer on staging can promote to prod?)

**Result:** RBAC covered by 8 test cases. All RBAC violations properly blocked. SOC2 auditor reviewed audit log format and approved. Gaps tracked.
**Assessed by:** Dani Reeves (QA Lead)

---

## Entry 6: BUG-003 Queue Corruption — Platform Resilience (Round 6)

**Date:** 2025-09-10
**Change:** P0 incident — RBAC migration locked the deploy queue for 4 hours. ADR-008 (WAL-based recovery) and ADR-009 (break-glass bypass) introduced.
**Impact:** No resilience or chaos tests existed. All prior test suites assumed Pave was always available. The incident proved that platform availability is itself a test requirement.

**Items reevaluated:**
- test-plan.md: platform resilience elevated — "Pave down" must have a tested fallback
- Suite 1 (Core Deploy Safety): reviewed all TCs — none cover Pave being unavailable
- coverage-report.md: US-010 and US-011 rows were empty

**Items added:**
- Suite 5 (Platform Resilience): TC-501 through TC-506 — queue normal operation, queue rebuild from events, manual bypass procedure, bypass procedure offline, recovery without duplicates, corruption detection
- test-plan.md: chaos test type added; chaos lab environment added; queue recovery added to exit criteria
- coverage-report.md: US-010 mapped to TC-503, TC-504; US-011 mapped to TC-501, TC-502, TC-505, TC-506

**Coverage gaps identified:**
- TC-505 (recovery without duplicates) only tested with clean shutdown — mid-write crash simulation pending
- Database migration safety not tested (the original cause) — need a TC for online DDL behavior

**Result:** Resilience covered by 6 test cases (5 pass, 1 suspect). Bypass procedure verified in incident drill by Sasha Petrov. Queue rebuild verified. TC-505 requires chaos test with mid-write crash.
**Assessed by:** Dani Reeves (QA Lead)

---

## Entry 7: US-012/US-013 Deploy Metrics — Counter-Propose to VP (Round 7)

**Date:** 2025-09-25
**Change:** VP mandated deploy frequency KPI. Teams gamed it. Marcus counter-proposed deploy health metrics. ADR-010 (Deploy Classification Engine) introduced. Dashboard redesigned from frequency to health.
**Impact:** No metrics tests existed. The dashboard was new. Classification logic needed verification to prevent gaming.

**Items reevaluated:**
- Suite 4 (RBAC & Audit), TC-406: audit log records deploys — metrics are derived from the same data. No impact.
- coverage-report.md: US-012 and US-013 rows were empty

**Items added:**
- Suite 6 (Deploy Metrics): TC-601 through TC-606 — feature deploy classification, trivial deploy (README), config change, health dashboard accuracy, trivial exclusion from KPI, team-relative baseline
- coverage-report.md: US-012 mapped to TC-604..606; US-013 mapped to TC-601..603

**Coverage gaps identified:**
- TC-606 (team-relative baseline) requires 30-day historical data not yet available in staging
- Migration-only deploys not tested against classifier
- Classification edge case: commit that changes both README and source code — how is it classified?

**Result:** Metrics covered by 6 test cases (5 pass, 1 pending data). Classification verified for feature, README, and config deploys. Dashboard accuracy verified against Prometheus. Gaps tracked.
**Assessed by:** Dani Reeves (QA Lead)

---

## Entry 8: US-014/US-015 Secrets Management (Round 8)

**Date:** 2025-10-10
**Change:** Team Sentry secret rotation incident. ADR-011 (Runtime Secrets Injection via Sidecar) and ADR-012 (Secrets Rotation Event Bus) introduced.
**Impact:** No secrets tests existed. Secrets were previously outside Pave's scope. New CLI commands (`pave secrets rotate`) and sidecar injection mechanism needed verification.

**Items reevaluated:**
- Suite 3 (Onboarding), TC-301/TC-302: pave.yaml validation — does it validate secret references? Added to TC-704
- Suite 4 (RBAC), TC-401..405: RBAC covers deploys but not secrets — do role permissions extend to `pave secrets`?
- coverage-report.md: US-014 and US-015 rows were empty

**Items added:**
- Suite 7 (Secrets Management): TC-701 through TC-706 — zero-downtime rotation, rolling restart fallback, audit trail, path-based reference validation, expired secret detection, emergency rotation
- coverage-report.md: US-014 mapped to TC-701, TC-702, TC-704..706; US-015 mapped to TC-703

**Coverage gaps identified:**
- TC-706 (emergency rotation) requires Vault admin access in staging — pending provisioning
- Non-K8s secrets injection (Docker Compose sidecar) untested
- RBAC for secrets rotation not explicitly tested (who can run `pave secrets rotate`?)

**Result:** Secrets covered by 6 test cases (5 pass, 1 pending environment). Zero-downtime rotation verified for K8s services. Sidecar and rolling restart paths both tested. Non-K8s gap tracked.
**Assessed by:** Sasha Petrov (DevOps/SRE)

---

## Entry 9: US-016/US-017 PCI Compliance Gates (Round 9)

**Date:** 2025-11-05
**Change:** PCI DSS v4.0 deadline. ADR-013 (Approval Gate Middleware) and ADR-014 (PCI Scope Tagging) introduced. Deploy to PCI-scoped services requires security team sign-off.
**Impact:** No compliance gate tests existed. All prior deploy tests assumed deploys proceed immediately. PCI introduces a blocking approval step.

**Items reevaluated:**
- Suite 1, TC-101 (atomic deploy): does the approval gate interact with the single-commit check? Determined: commit check runs first, then approval gate. No conflict.
- Suite 2, TC-201..208 (canary): does canary on a PCI service require approval? Flagged as gap — unclear if approval fires before canary start or before promote.
- Suite 4, TC-401..405 (RBAC): RBAC determines who can deploy and who can approve. Approval role is distinct from deployer role. No impact on existing RBAC tests.
- coverage-report.md: US-016 and US-017 rows were empty

**Items added:**
- Suite 8 (PCI Approval): TC-801 through TC-806 — approval required, approved flow, rejected flow, non-PCI bypass, SLA escalation, approval audit trail
- coverage-report.md: US-016 mapped to TC-801..804, TC-806; US-017 mapped to TC-805
- test-plan.md: PCI gate added to exit criteria; PCI auditor listed in assumptions

**Coverage gaps identified:**
- Canary + PCI interaction not tested (approval gate timing for canary deploys)
- Approval workflow when approver is unavailable (vacation, out of office) — does escalation designate a backup?

**Result:** PCI approval covered by 6 test cases. Full workflow tested end-to-end including escalation. PCI auditor observed the test execution and approved the gate design. Two cross-feature gaps tracked.
**Assessed by:** Dani Reeves (QA Lead)

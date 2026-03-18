# Test Plan — Pave Deploy Platform

**QA Lead:** Dani Reeves
**Last updated:** After Round 9
**System:** Pave (CLI, Web Dashboard, API, Deploy Pipeline, Secrets Sidecar)
**Confirmed by:** Dani Reeves (QA Lead), 2025-11-20

**Traceability:** This plan references [user stories](../product/epics.md), [CLI spec](../experience/cli-spec.md), [dashboard specs](../experience/dashboard-specs.md), [API spec](../architecture/api-spec.md), [ADRs](../architecture/adrs.md), and [monitoring/alerting](../operations/monitoring-alerting.md). Test cases are in [test-suites.md](test-suites.md). Coverage analysis is in [coverage-report.md](coverage-report.md). Bug history is in [bug-reports.md](bug-reports.md).

---

## 1. Scope

This plan covers all testing activities for the Pave deploy platform across 9 rounds of development. It addresses:

- Core deploy safety — atomic single-commit deploys, instant rollback, drift detection — [US-001](../product/epics.md#us-001-atomic-single-commit-deploys), [US-002](../product/epics.md#us-002-instant-rollback-under-2-minutes), [US-003](../product/epics.md#us-003-drift-detection)
- Multi-commit blame fix ([BUG-001](bug-reports.md#bug-001-multi-commit-deploy-with-unknown-blame)) — [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy)
- Bypass overwrite fix ([BUG-002](bug-reports.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix)) — [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting)
- Progressive rollout — canary deploys with traffic splitting, auto-rollback — [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting), [US-005](../product/epics.md#us-005-auto-rollback-on-error-threshold), [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting)
- Multi-stack onboarding — pave.yaml validation, Docker Compose support — [US-006](../product/epics.md#us-006-compatibility-mode-for-non-k8s-stacks), [US-007](../product/epics.md#us-007-service-definition-schema--paveyaml), [ADR-004](../architecture/adrs.md#adr-004-pave-yaml-service-definition-schema), [ADR-005](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support)
- RBAC and audit trail — [US-008](../product/epics.md#us-008-full-deploy-audit-trail), [US-009](../product/epics.md#us-009-rbac-per-team-x-environment), [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix), [ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture)
- Platform resilience — break-glass bypass, queue recovery — [US-010](../product/epics.md#us-010-manual-bypass-when-pave-is-down), [US-011](../product/epics.md#us-011-deploy-queue-resilience), [BUG-003](bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration), [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure)
- Deploy metrics — health dashboard, deploy classification — [US-012](../product/epics.md#us-012-deploy-health-dashboard), [US-013](../product/epics.md#us-013-deploy-classification), [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine)
- Secrets management — rotation without redeploy, audit trail — [US-014](../product/epics.md#us-014-secrets-rotation-without-redeploy), [US-015](../product/epics.md#us-015-secrets-rotation-audit-trail), [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus)
- PCI compliance gates — approval workflow, SLA enforcement — [US-016](../product/epics.md#us-016-pci-deploy-approval-workflow), [US-017](../product/epics.md#us-017-30-minute-sla-on-approvals), [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern), [ADR-014](../architecture/adrs.md#adr-014-pci-scope-tagging-in-pave-yaml)

---

## 2. Testing Strategy

### 2.1 Test Types

| Type | Purpose | Tools / Approach | Key Stories |
|------|---------|------------------|-------------|
| Functional | Verify acceptance criteria for every user story and bug fix | Manual test execution against [test cases](test-suites.md), automated regression | All user stories |
| Integration | CLI → API → K8s/Docker pipeline end-to-end | Automated E2E with real cluster, [API contract](../architecture/api-spec.md) tests | [US-001](../product/epics.md#us-001-atomic-single-commit-deploys), [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting), [US-006](../product/epics.md#us-006-compatibility-mode-for-non-k8s-stacks) |
| Security / RBAC | Permission boundaries, audit log integrity, secret isolation | Automated RBAC matrix tests, manual penetration testing | [US-008](../product/epics.md#us-008-full-deploy-audit-trail), [US-009](../product/epics.md#us-009-rbac-per-team-x-environment), [US-014](../product/epics.md#us-014-secrets-rotation-without-redeploy) |
| Performance / Load | Verify deploy pipeline handles concurrent deploys from 20 teams | Load test with simulated concurrent `pave deploy` across teams | [US-011](../product/epics.md#us-011-deploy-queue-resilience) |
| Chaos | Verify resilience when Pave components fail mid-deploy | Kill Pave API during deploy, corrupt queue, drop network | [US-010](../product/epics.md#us-010-manual-bypass-when-pave-is-down), [US-011](../product/epics.md#us-011-deploy-queue-resilience), [BUG-003](bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration) |
| Compliance | PCI approval gates enforced, audit log immutability | Manual audit with PCI auditor, automated gate enforcement tests | [US-016](../product/epics.md#us-016-pci-deploy-approval-workflow), [US-017](../product/epics.md#us-017-30-minute-sla-on-approvals) |
| Regression | Ensure new features don't break existing deploy flows | Automated suite run before each release | All |

### 2.2 Test Environments

| Environment | Purpose | Data |
|-------------|---------|------|
| Local (minikube) | Unit and integration testing during development | Single-node K8s cluster, synthetic services |
| Staging | Full regression, E2E, RBAC testing | Multi-namespace K8s cluster, 10 test teams, 30 test services |
| Staging (Docker Compose) | Non-K8s compatibility testing | Docker Compose stack, Gridline-representative services |
| Prod Canary | Canary deploy verification against real traffic | Production cluster, 1-5% traffic routing |
| Chaos Lab | Resilience and failure mode testing | Staging cluster with Chaos Monkey / LitmusChaos |

### 2.3 Test Data Requirements

- **Team pool:** 10 test teams with distinct RBAC configurations (deployer, viewer, lead, intern roles per team)
- **Service pool:** 30 test services across K8s (Deployment, StatefulSet), Docker Compose, and bare-metal stacks
- **pave.yaml variants:** Valid K8s, valid Docker Compose, valid bare-metal, missing required fields, invalid runtime, deprecated schema version
- **Deploy artifacts:** Known-good and known-bad Docker images for canary testing (one with injected error rate > 5%)
- **Secrets:** Test Vault paths with rotatable secrets (Redis creds, API keys) for rotation testing
- **PCI-scoped services:** 3 services tagged `pci: true` in pave.yaml for approval workflow testing

---

## 3. Priority and Risk Areas

### Critical (must-pass before any release)

1. **Atomic deploy safety ([BUG-001](bug-reports.md#bug-001-multi-commit-deploy-with-unknown-blame))** — every deploy maps to exactly one commit. Multi-commit deploys are rejected. Rollback under 2 minutes.
   - Tests: [TC-101](test-suites.md#tc-101-atomic-deploy--single-commit) through [TC-106](test-suites.md#tc-106-drift-detection--ssh-mutation)
   - Monitor: [Deploy Failure Rate](../operations/monitoring-alerting.md#deploy-pipeline-health)
2. **Bypass overwrite prevention ([BUG-002](bug-reports.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix))** — Pave must detect when production state diverges from expected state and block deploys until drift is resolved.
   - Tests: [TC-105](test-suites.md#tc-105-drift-detection--out-of-band-change-detected), [TC-106](test-suites.md#tc-106-drift-detection--ssh-mutation), [TC-110](test-suites.md#tc-110-deploy-blocked-when-drift-is-unresolved)
   - Monitor: [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)
3. **Deploy queue resilience ([BUG-003](bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration))** — queue recovers from corruption without losing deploys. No duplicate deploys after recovery.
   - Tests: [TC-501](test-suites.md#tc-501-event-sourced-queue--normal-operation) through [TC-506](test-suites.md#tc-506-queue-corruption-detection)
   - Monitor: [Deploy Queue Depth](../operations/monitoring-alerting.md#deploy-pipeline-health)
4. **Rollback correctness** — rollback restores the exact previous state, not a stale snapshot. Under 2 minutes end-to-end.
   - Tests: [TC-102](test-suites.md#tc-102-rollback--under-2-minutes), [TC-103](test-suites.md#tc-103-multi-commit-deploy--rejected)
   - Monitor: [Rollback Duration](../operations/monitoring-alerting.md#deploy-pipeline-health)

### High

5. **Canary auto-rollback** — error rate or latency threshold breach triggers automatic rollback, not manual intervention.
   - Tests: [TC-204](test-suites.md#tc-204-auto-rollback-on-error-rate-threshold), [TC-205](test-suites.md#tc-205-auto-rollback-on-latency-threshold)
   - Monitor: [Canary Error Rate](../operations/monitoring-alerting.md#canary-deploy-health)
6. **RBAC enforcement** — unauthorized users cannot deploy to environments they lack permissions for. Intern restrictions enforced.
   - Tests: [TC-401](test-suites.md#tc-401-deploy-to-prod--authorized) through [TC-405](test-suites.md#tc-405-role-grant-and-revoke)
   - Monitor: [RBAC Violations](../operations/monitoring-alerting.md#access-control)
7. **PCI approval gate** — no deploy to PCI-scoped service without security team sign-off. Escalation triggers at 30 minutes.
   - Tests: [TC-801](test-suites.md#tc-801-pci-deploy--approval-required) through [TC-806](test-suites.md#tc-806-approval-audit-trail)
   - Monitor: [PCI Approval SLA](../operations/monitoring-alerting.md#compliance-gates)

### Medium

8. **Secrets rotation** — services pick up new secrets without redeploy. Audit trail is complete.
   - Tests: [TC-701](test-suites.md#tc-701-secret-rotation--zero-downtime) through [TC-706](test-suites.md#tc-706-emergency-secret-rotation)
   - Monitor: [Expired Secret In Use](../operations/monitoring-alerting.md#alert-expired-secret-in-use)
9. **Deploy classification accuracy** — README-only deploys are not counted as substantive. Config changes are tagged correctly.
   - Tests: [TC-601](test-suites.md#tc-601-classification--feature-deploy) through [TC-606](test-suites.md#tc-606-team-relative-baseline-calculation)
   - Monitor: [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-metrics)
10. **Multi-stack onboarding** — Docker Compose services deploy through Pave without K8s dependency.
    - Tests: [TC-301](test-suites.md#tc-301-paveyaml-validation--valid-k8s-service) through [TC-306](test-suites.md#tc-306-onboarding-status-tracking)
    - Monitor: [Onboarding Failures](../operations/monitoring-alerting.md#onboarding)

---

## 4. Entry and Exit Criteria

### Entry Criteria (start testing)

- Feature code is deployed to staging cluster
- Unit tests pass (developer responsibility)
- API contract matches [spec](../architecture/api-spec.md)
- Test services and RBAC configurations are seeded in staging
- Pave CLI is built and published to staging artifact registry

### Exit Criteria (release approval)

- All critical test cases pass (zero failures)
- All high-priority test cases pass
- Medium-priority: no P0/P1 open defects, known P2s documented with workarounds
- Rollback test confirms < 2 minute recovery — verified by [TC-102](test-suites.md#tc-102-rollback--under-2-minutes)
- RBAC test confirms no unauthorized deploy paths — verified by [TC-401](test-suites.md#tc-401-deploy-to-prod--authorized) through [TC-405](test-suites.md#tc-405-role-grant-and-revoke)
- PCI gate enforced end-to-end including escalation — verified by [TC-801](test-suites.md#tc-801-pci-deploy--approval-required) through [TC-806](test-suites.md#tc-806-approval-audit-trail)
- Chaos test confirms queue recovery — verified by [TC-502](test-suites.md#tc-502-event-sourced-queue--rebuild-from-events)
- Regression suite passes (no regressions from prior rounds)
- All [production monitors](../operations/monitoring-alerting.md) are active and thresholds configured

---

## 5. Test Execution by Round

| Round | What Happened | Test Focus | Stories | Architecture |
|-------|---------------|------------|---------|--------------|
| 1 | Team Falcon multi-commit deploy breaks checkout | Atomic deploys, single-commit enforcement, rollback | [US-001](../product/epics.md#us-001-atomic-single-commit-deploys), [US-002](../product/epics.md#us-002-instant-rollback-under-2-minutes), [BUG-001](bug-reports.md#bug-001-multi-commit-deploy-with-unknown-blame) | [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy) |
| 2 | On-call SSH overwrite, Pave reverts the fix | Drift detection, bypass prevention, deploy blocking | [US-003](../product/epics.md#us-003-drift-detection), [BUG-002](bug-reports.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix) | [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) |
| 3 | Payments team wants canary deploys | Canary traffic splitting, promote, abort, auto-rollback | [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting), [US-005](../product/epics.md#us-005-auto-rollback-on-error-threshold) | [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) |
| 4 | Gridline acquisition — non-K8s stack | pave.yaml validation, Docker Compose adapter, `pave init` | [US-006](../product/epics.md#us-006-compatibility-mode-for-non-k8s-stacks), [US-007](../product/epics.md#us-007-service-definition-schema--paveyaml) | [ADR-004](../architecture/adrs.md#adr-004-pave-yaml-service-definition-schema), [ADR-005](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support) |
| 5 | SOC2 audit — no RBAC, intern deployed to prod | RBAC enforcement, audit trail, role management | [US-008](../product/epics.md#us-008-full-deploy-audit-trail), [US-009](../product/epics.md#us-009-rbac-per-team-x-environment) | [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix), [ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture) |
| 6 | RBAC migration locks deploy queue 4 hours | Queue resilience, break-glass bypass, recovery | [US-010](../product/epics.md#us-010-manual-bypass-when-pave-is-down), [US-011](../product/epics.md#us-011-deploy-queue-resilience), [BUG-003](bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration) | [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure) |
| 7 | VP mandates deploy frequency KPI, teams game it | Deploy classification, health dashboard, metrics accuracy | [US-012](../product/epics.md#us-012-deploy-health-dashboard), [US-013](../product/epics.md#us-013-deploy-classification) | [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine) |
| 8 | Team Sentry secret rotation takes down service at 2 AM | Secret rotation without redeploy, audit trail, expired secret detection | [US-014](../product/epics.md#us-014-secrets-rotation-without-redeploy), [US-015](../product/epics.md#us-015-secrets-rotation-audit-trail) | [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus) |
| 9 | PCI DSS v4.0 compliance deadline | Approval workflow, SLA enforcement, escalation | [US-016](../product/epics.md#us-016-pci-deploy-approval-workflow), [US-017](../product/epics.md#us-017-30-minute-sla-on-approvals) | [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern), [ADR-014](../architecture/adrs.md#adr-014-pci-scope-tagging-in-pave-yaml) |

---

## 6. Defect Management

- **P0 (Critical/Production):** Fix within 4 hours. Blocks all releases. Example: deploy queue corruption, bypass overwrite. Monitor: [Pave Down](../operations/monitoring-alerting.md#pave-down-runbook).
- **P1 (High):** Fix this sprint. Core safety feature broken. Example: multi-commit deploy accepted, rollback exceeds 2 min. Monitor: [Deploy Failure Rate](../operations/monitoring-alerting.md#deploy-pipeline-health).
- **P2 (Medium):** Fix next sprint. Functional issue with workaround. Example: classification tags wrong for config-only deploys. Monitor: [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-metrics).
- **P3 (Low):** Backlog. Cosmetic, edge-case, or enhancement.

All bugs are logged in [bug-reports.md](bug-reports.md) with: summary, steps to reproduce, expected vs actual, severity, environment, root cause (when identified), traceability to affected story and ADR.

---

## 7. Assumptions and Dependencies

- Staging K8s cluster is available with multiple namespaces for team isolation
- Docker Compose test environment mirrors Gridline's stack (Node.js + Postgres + Redis)
- HashiCorp Vault dev instance available for secrets rotation testing
- Istio service mesh available in staging for canary traffic splitting — see [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting)
- PCI auditor available for gate design review — see [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern)
- All [production monitors](../operations/monitoring-alerting.md) are deployed and operational before release
- Platform Engineering team (Kai Tanaka, Sasha Petrov) provides API documentation matching the [spec](../architecture/api-spec.md)

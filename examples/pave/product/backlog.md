# Backlog

Prioritized by urgency, dependency order, and business impact.

| # | Story | Epic | Priority | Status | Key Links | Confirmed by |
|---|-------|------|----------|--------|-----------|-------------|
| BUG-003 | Deploy queue corruption during RBAC migration | E5 | P0 | Done | [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [TC-504–505](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash), [Bug report](../quality/bug-reports.md#bug-003-deploy-queue-locked-during-rbac-migration) | Kai Tanaka, 2025-09-10 |
| BUG-001 | Multi-commit deploy with unknown blame | E1 | P1 | Done | [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy), [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), [TC-102](../quality/test-suites.md#tc-102-atomic-deploy--multi-commit-rejected), [Bug report](../quality/bug-reports.md#bug-001-multi-commit-deploy-caused-40-minute-outage) | Kai Tanaka, 2025-06-20 |
| BUG-002 | Bypass overwrite — Pave reverts manual hotfix | E1 | P1 | Done | [CLI: `pave status`](../experience/cli-spec.md#pave-status), [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting), [TC-106–108](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation), [Bug report](../quality/bug-reports.md#bug-002-pave-overwrote-manual-hotfix-causing-transaction-loss) | Sasha Petrov, 2025-07-10 |
| US-001 | Atomic single-commit deploys | E1 | P1 | Done | [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy), [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), [TC-101–103](../quality/test-suites.md#tc-101-atomic-deploy--single-commit) | Kai Tanaka, 2025-06-20 |
| US-002 | Instant rollback under 2 minutes | E1 | P1 | Done | [CLI: `pave rollback`](../experience/cli-spec.md#pave-rollback), [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), [TC-104–105](../quality/test-suites.md#tc-104-rollback--under-2-minutes) | Sasha Petrov, 2025-06-25 |
| US-008 | Full deploy audit trail | E4 | P1 | Done | [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view), [ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture), [TC-404–406](../quality/test-suites.md#tc-404-audit-log--deploy-event-complete) | Marcus Chen, 2025-09-01 |
| US-009 | RBAC per team x environment | E4 | P1 | Done | [CLI: permission errors](../experience/cli-spec.md#pave-deploy--permission-denied), [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix), [TC-401–403](../quality/test-suites.md#tc-401-rbac--team-member-deploys-to-allowed-env) | Marcus Chen, 2025-09-01 |
| US-010 | Manual bypass when Pave is down | E5 | P1 | Done | [CLI: `pave bypass`](../experience/cli-spec.md#pave-bypass), [Runbook](../operations/monitoring-alerting.md#pave-down-runbook), [TC-501–503](../quality/test-suites.md#tc-501-break-glass--manual-deploy-when-pave-is-down) | Sasha Petrov, 2025-09-10 |
| US-016 | PCI deploy approval workflow | E8 | P1 | Done | [CLI: `pave deploy` approval](../experience/cli-spec.md#pave-deploy--approval-required), [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern), [TC-801–803](../quality/test-suites.md#tc-801-pci-deploy--approval-required-before-prod) | Marcus Chen, 2025-11-10 |
| US-017 | 30-minute SLA on approvals | E8 | P1 | Done | [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue), [Alert: SLA Breach](../operations/monitoring-alerting.md#alert-approval-sla-breach), [TC-804–805](../quality/test-suites.md#tc-804-pci-approval--sla-tracking) | Marcus Chen, 2025-11-15 |
| US-003 | Drift detection | E1 | P2 | Suspect | [CLI: `pave status`](../experience/cli-spec.md#pave-status), [Dashboard: Drift Alerts](../experience/dashboard-specs.md#drift-alert-panel), [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting), [TC-106–108](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation) | Kai Tanaka, 2025-07-15 |
| US-004 | Canary deploy with traffic splitting | E2 | P2 | Done | [CLI: `pave deploy --canary`](../experience/cli-spec.md#pave-deploy---canary), [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status), [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting), [TC-201–203](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split) | Kai Tanaka, 2025-08-01 |
| US-007 | Service definition schema — pave.yaml | E3 | P2 | Done | [CLI: `pave init`](../experience/cli-spec.md#pave-init), [CLI: `pave validate`](../experience/cli-spec.md#pave-validate), [ADR-004](../architecture/adrs.md#adr-004-pave-yaml-service-definition-schema), [TC-303–305](../quality/test-suites.md#tc-303-pave-validate--valid-config) | Rina Okafor, 2025-08-15 |
| US-011 | Deploy queue resilience | E5 | P2 | Suspect | [Dashboard: Queue Health](../experience/dashboard-specs.md#deploy-queue-health), [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [TC-504–505](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash) | Kai Tanaka, 2025-09-15 |
| US-012 | Deploy health dashboard | E6 | P2 | Done | [Dashboard: Deploy Health](../experience/dashboard-specs.md#deploy-health-dashboard), [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine), [TC-601–603](../quality/test-suites.md#tc-601-dashboard--success-rate-calculation) | Marcus Chen, 2025-10-01 |
| US-014 | Secrets rotation without redeploy | E7 | P2 | Done | [CLI: `pave secrets rotate`](../experience/cli-spec.md#pave-secrets-rotate), [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [TC-701–703](../quality/test-suites.md#tc-701-secrets-rotation--zero-downtime) | Sasha Petrov, 2025-10-15 |
| US-005 | Auto-rollback on error threshold | E2 | P3 | Suspect | [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status), [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting), [TC-204–205](../quality/test-suites.md#tc-204-canary-auto-rollback--error-rate-breach) | Marcus Chen, 2025-08-01 |
| US-006 | Compatibility mode for non-K8s stacks | E3 | P3 | Suspect | [CLI: `pave init`](../experience/cli-spec.md#pave-init), [Onboarding: Docker Compose](../experience/onboarding-flows.md#onboarding-docker-compose), [ADR-005](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support), [TC-301–306](../quality/test-suites.md#tc-301-onboarding--k8s-service-via-pave-init) | Kai Tanaka, 2025-08-20 |
| US-013 | Deploy classification | E6 | P3 | Suspect | [Dashboard: Deploy Health](../experience/dashboard-specs.md#deploy-health-dashboard), [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine), [TC-604–605](../quality/test-suites.md#tc-604-classification--feature-deploy-tagged) | Rina Okafor, 2025-10-01 |
| US-015 | Secrets rotation audit trail | E7 | P3 | Suspect | [Dashboard: Secrets Status](../experience/dashboard-specs.md#secrets-rotation-status), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus), [TC-704–705](../quality/test-suites.md#tc-704-secrets-audit--rotation-event-recorded) | Marcus Chen, 2025-10-20 |

---

## Coverage Gaps

Items surfaced through reconciliation (REC-010 CTO review) and ongoing verification. These are untested areas that need test coverage or explicit risk acceptance.

### Drift Detection

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-001 | Drift detection for Docker Compose / non-K8s workloads | P2 — Gridline has no drift protection. If someone SSH's to a Gridline host, Pave won't know. | Needs adapter extension |
| GAP-002 | Drift detection for ECS workloads | P3 — No ECS teams yet, but 2 are planned. | Blocked on ECS adapter |

### Canary / Progressive Rollout

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-003 | Latency-based auto-rollback threshold | P2 — Error rate threshold works, but latency spikes won't trigger auto-rollback. | TC-205 defined, not executed |
| GAP-004 | Auto-rollback notification delivery verification | P3 — Auto-rollback happens but notification to deployer not verified. | Needs TC |

### Multi-Stack Onboarding

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-005 | ECS adapter implementation and testing | P2 — 2 teams waiting for ECS support. | Blocked on engineering capacity |
| GAP-006 | Bare metal support | P3 — No teams requesting yet, but one legacy service may need it. | Deferred |

### Platform Resilience

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-007 | Mid-write crash recovery for deploy queue | P2 — Clean shutdown recovery works, but crash during active write untested. Requires chaos engineering setup. | Needs chaos test |
| GAP-008 | Break-glass bypass for non-K8s runtimes | P3 — Bypass procedure tested for K8s only. Docker Compose bypass not documented. | Needs runbook update |

### Deploy Classification

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-009 | Classification of config-only deploys | P3 — Heuristic catches README deploys but not config-only or migration-only. | Needs heuristic update |
| GAP-010 | Classification override path | P3 — Teams should be able to correct misclassified deploys. UI path untested. | Needs TC |

### Secrets Management

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-011 | Secrets injection for Docker Compose stacks | P2 — Sidecar pattern assumes K8s. Gridline has no secrets injection. | Needs architecture spike |
| GAP-012 | Cross-service consumption tracking for non-K8s | P3 — Audit trail for K8s, not for Docker Compose. | Depends on GAP-011 |

---

## Priority definitions
- **P0:** Fix now. Platform outage, compliance violation, credibility crisis.
- **P1:** Fix this sprint. Core capability broken, compliance deadline, or blocking other teams.
- **P2:** Next up. High value, needed soon, or unblocks growth.
- **P3:** Planned. Important but can wait for dependencies or capacity.

## Sequencing notes

**Immediate (completed):**
- BUG-003 first — 4-hour outage is an existential credibility issue
- BUG-001 + BUG-002 in parallel — deploy safety is foundational
- US-001, US-002 — atomic deploys and instant rollback are the core value prop

**Next wave (completed):**
- US-008, US-009 — SOC2 remediation
- US-010 — break-glass bypass (learned the hard way from BUG-003)
- US-007 — pave.yaml schema enables everything downstream

**Current sprint:**
- US-016, US-017 — PCI gates (certification deadline)
- US-004, US-012 — canary and metrics dashboard (high visibility, VP watching)

**Next sprint:**
- US-003 gap closure — drift detection for non-K8s (Gridline exposure)
- US-005 — auto-rollback latency threshold (canary is incomplete without it)
- US-011 — queue chaos testing (credibility gap from REC-010)

**Following sprints:**
- US-006 — ECS adapter (2 teams waiting)
- US-013 — classification heuristic expansion
- US-014/US-015 — secrets injection for non-K8s stacks

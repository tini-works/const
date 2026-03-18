# Epics

## E1: Deploy Safety & Traceability

**Goal:** Every deploy is traceable to exactly one change, and any deploy can be rolled back instantly.

**Origin:** Round 1 — Team Falcon merged 3 PRs and deployed Friday 5 PM. Checkout broke. 40 minutes to identify which commit caused it. Rollback was manual and painful.

**Scope:**
- Enforce atomic single-commit deploys — one commit per deploy, no batching
- Instant rollback under 2 minutes, automated, no SSH required
- Drift detection — Pave must know when production state diverges from expected state
- Deploy blame is always unambiguous — every production state maps to exactly one commit

**Known issues:**
- Multi-commit deploy with unknown blame (Round 1) — resolved as BUG-001
- Bypass overwrite: on-call SSH'd to prod, Pave deployed old code over the fix (Round 2) — resolved as BUG-002
- Deploy queue corruption during RBAC migration (Round 6) — resolved as BUG-003

**Dependencies:** E5 (platform resilience — Pave must stay up for deploys to be safe).

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-001](user-stories.md#us-001-atomic-single-commit-deploys), [US-002](user-stories.md#us-002-instant-rollback-under-2-minutes), [US-003](user-stories.md#us-003-drift-detection) |
| Bug Stories | [BUG-001](user-stories.md#bug-001-multi-commit-deploy-with-unknown-blame), [BUG-002](user-stories.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix) |
| Decisions | [DEC-001](decision-log.md#dec-001-every-deploy-is-exactly-one-commit), [DEC-002](decision-log.md#dec-002-detect-drift-not-just-prevent-bypass) |
| Architecture | [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) |
| Experience | [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy), [CLI: `pave rollback`](../experience/cli-spec.md#pave-rollback), [CLI: `pave status`](../experience/cli-spec.md#pave-status) |
| Quality | [TC-101](../quality/test-suites.md#tc-101-atomic-deploy--single-commit) through [TC-106](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation) |
| Confirmed by | Marcus Chen (Platform Engineering Lead), 2025-06-20 |

**Verification:** 2/3 stories proven, 1 suspect (US-003 — drift detection for non-K8s workloads untested after E3 onboarding expanded scope). 2/2 bugs proven. Last verified 2025-07-15.

---

## E2: Progressive Rollout

**Goal:** Teams can deploy to a percentage of traffic first, validate, then roll forward — or auto-rollback on failure.

**Origin:** Round 3 — Team Atlas (payments) wants canary deploys to 5% of traffic, validate error rates, then roll forward.

**Scope:**
- Canary deploys with configurable traffic splitting (1%–50%)
- Automated health checks during canary window
- Auto-rollback when error threshold is breached
- Available to all teams, not just payments

**Dependencies:** E1 (rollback mechanism is shared).

**See:** [PRD — Canary Deploys](prd-canary-deploys.md)

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-004](user-stories.md#us-004-canary-deploy-with-traffic-splitting), [US-005](user-stories.md#us-005-auto-rollback-on-error-threshold) |
| PRD | [PRD: Canary Deploys](prd-canary-deploys.md) |
| Decisions | [DEC-003](decision-log.md#dec-003-canary-available-to-all-teams-not-just-payments) |
| Architecture | [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) |
| Experience | [CLI: `pave deploy --canary`](../experience/cli-spec.md#pave-deploy---canary), [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status) |
| Quality | [TC-201](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split) through [TC-205](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach) |
| Confirmed by | Marcus Chen (Platform Engineering Lead), 2025-07-10 |

**Verification:** 1/2 stories proven (US-004), 1 suspect (US-005 — auto-rollback triggers on error rate but latency-based threshold untested). Last verified 2025-08-01.

---

## E3: Multi-Stack Onboarding

**Goal:** Any team — regardless of their stack — can onboard to Pave within days, not months.

**Origin:** Round 4 — Gridline (acquired startup, 30 people, Bash scripts + Docker Compose, no K8s) must be on Pave within 90 days for SOC2 compliance.

**Scope:**
- Compatibility mode for non-K8s workloads (Docker Compose, ECS, bare metal)
- Service definition schema (`pave.yaml`) as the universal contract
- Guided onboarding flow with validation
- Documentation and templates for common stacks

**Dependencies:** E1 (deploy safety applies to all stacks), E4 (RBAC must cover Gridline teams).

**See:** [PRD — Multi-Stack Onboarding](prd-multi-stack-onboarding.md)

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-006](user-stories.md#us-006-compatibility-mode-for-non-k8s-stacks), [US-007](user-stories.md#us-007-service-definition-schema--paveyaml) |
| PRD | [PRD: Multi-Stack Onboarding](prd-multi-stack-onboarding.md) |
| Decisions | [DEC-004](decision-log.md#dec-004-onboarding-via-service-definition-schema-not-custom-integrations) |
| Architecture | [ADR-004](../architecture/adrs.md#adr-004-pave-yaml-service-definition-schema), [ADR-005](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support) |
| Experience | [CLI: `pave init`](../experience/cli-spec.md#pave-init), [CLI: `pave validate`](../experience/cli-spec.md#pave-validate), [Onboarding Flow](../experience/onboarding-flows.md#guided-onboarding) |
| Quality | [TC-301](../quality/test-suites.md#tc-301-onboarding--k8s-service-via-pave-init) through [TC-306](../quality/test-suites.md#tc-306-onboarding--docker-compose-to-pave) |
| Confirmed by | Marcus Chen (Platform Engineering Lead), 2025-08-05 |

**Verification:** 1/2 stories proven (US-007 — schema validation works), 1 suspect (US-006 — Docker Compose adapter tested with Gridline's stack but ECS adapter untested). Last verified 2025-08-20.

---

## E4: Access Control & Audit

**Goal:** Every deploy action is attributable to a person, and permissions are scoped to what each team actually needs.

**Origin:** Round 5 — SOC2 audit found no RBAC. Every engineer has deploy access to every environment. An intern deployed to prod twice. Auditor flagged it.

**Scope:**
- Full audit trail: who deployed what, when, where, and what happened
- RBAC at team x environment granularity (e.g., Team Falcon can deploy to staging, only leads can deploy to prod)
- Role management via team ownership, not individual grants
- Audit log immutable and queryable

**Dependencies:** E1 (audit trail extends deploy traceability), E3 (Gridline teams need RBAC on day one).

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-008](user-stories.md#us-008-full-deploy-audit-trail), [US-009](user-stories.md#us-009-rbac-per-team-x-environment) |
| Decisions | [DEC-005](decision-log.md#dec-005-rbac-at-team-x-environment-granularity) |
| Architecture | [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix), [ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture) |
| Experience | [CLI: `pave deploy` permission errors](../experience/cli-spec.md#pave-deploy--permission-denied), [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view) |
| Quality | [TC-401](../quality/test-suites.md#tc-401-rbac--team-member-deploys-to-allowed-env) through [TC-406](../quality/test-suites.md#tc-406-audit-log--deploy-event-recorded) |
| Confirmed by | Marcus Chen (Platform Engineering Lead), 2025-08-15 |

**Verification:** 2/2 stories proven. All AC covered, SOC2 auditor reviewed audit log format. Last verified 2025-09-01.

---

## E5: Platform Resilience

**Goal:** When Pave itself breaks, teams can still ship critical fixes, and the deploy queue recovers without data loss.

**Origin:** Round 6 — RBAC migration bug locked the deploy_queue table for 4 hours. Nobody could deploy. Three teams had P1 fixes queued.

**Scope:**
- Documented manual bypass procedure when Pave is down (break-glass)
- Deploy queue resilience — no single migration or internal failure should block all deploys
- Queue state recovery after failure without losing queued deploys

**Known issues:**
- Queue corruption during RBAC table migration (Round 6) — resolved as BUG-003

**Dependencies:** E4 (RBAC migration was the trigger — future migrations must be non-blocking).

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-010](user-stories.md#us-010-manual-bypass-when-pave-is-down), [US-011](user-stories.md#us-011-deploy-queue-resilience) |
| Bug Stories | [BUG-003](user-stories.md#bug-003-deploy-queue-corruption-during-rbac-migration) |
| Architecture | [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure) |
| Experience | [CLI: `pave bypass`](../experience/cli-spec.md#pave-bypass), [Dashboard: Queue Health](../experience/dashboard-specs.md#deploy-queue-health) |
| Operations | [Runbook: Pave Down](../operations/monitoring-alerting.md#pave-down-runbook) |
| Quality | [TC-501](../quality/test-suites.md#tc-501-break-glass--manual-deploy-when-pave-is-down) through [TC-504](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash) |
| Confirmed by | Sasha Petrov (DevOps/SRE), 2025-09-10 |

**Verification:** 1/2 stories proven (US-010 — bypass procedure tested in incident drill), 1 suspect (US-011 — queue recovery tested with clean shutdown but not with mid-write crash). Last verified 2025-09-15.

---

## E6: Meaningful Deploy Metrics

**Goal:** Measure what matters — deploy health, not deploy vanity. Give teams and leadership actionable data instead of gameable numbers.

**Origin:** Round 7 — VP Amy Nakamura mandated "10 deploys per team per week." Teams gamed it. Split PRs, deployed README changes. Frequency tripled, failure rate tripled.

**Scope:**
- Deploy health dashboard: success rate, MTTR, change failure rate, lead time
- Deploy classification: distinguish meaningful deploys from noise (config changes, README updates)
- Team-level and org-level views
- No raw frequency as a KPI

**Dependencies:** E4 (audit data feeds metrics), E1 (deploy traceability feeds classification).

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-012](user-stories.md#us-012-deploy-health-dashboard), [US-013](user-stories.md#us-013-deploy-classification) |
| Decisions | [DEC-006](decision-log.md#dec-006-counter-propose-deploy-health-metrics-to-vp) |
| Architecture | [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine) |
| Experience | [Dashboard: Deploy Health](../experience/dashboard-specs.md#deploy-health-dashboard), [Dashboard: Team View](../experience/dashboard-specs.md#team-deploy-metrics) |
| Quality | [TC-601](../quality/test-suites.md#tc-601-dashboard--success-rate-calculation) through [TC-605](../quality/test-suites.md#tc-605-classification--readme-deploy-tagged-as-non-substantive) |
| Confirmed by | Marcus Chen (Platform Engineering Lead), 2025-09-25 |

**Verification:** 1/2 stories proven (US-012 — dashboard renders correct metrics), 1 suspect (US-013 — classification heuristic catches README deploys but hasn't been tested against config-only or migration-only deploys). Last verified 2025-10-01.

---

## E7: Secrets Management

**Goal:** Rotating secrets should not require coordinated deploys across services.

**Origin:** Round 8 — Team Sentry rotates Redis creds every 90 days, requiring coordinated deploys of 6 services. Last time, one service missed and went down at 2 AM.

**Scope:**
- Secrets injected at runtime, not baked into deploy artifacts
- Rotation without redeploy — services pick up new secrets automatically
- Rotation audit trail: who rotated, when, which services consumed the new secret
- Alerting when a service is still using an expired secret

**Dependencies:** E4 (RBAC applies to secrets access), E3 (non-K8s stacks need secrets too).

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-014](user-stories.md#us-014-secrets-rotation-without-redeploy), [US-015](user-stories.md#us-015-secrets-rotation-audit-trail) |
| Decisions | [DEC-007](decision-log.md#dec-007-secrets-rotation-is-platform-responsibility) |
| Architecture | [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus) |
| Experience | [CLI: `pave secrets rotate`](../experience/cli-spec.md#pave-secrets-rotate), [Dashboard: Secrets Status](../experience/dashboard-specs.md#secrets-rotation-status) |
| Operations | [Alert: Expired Secret Still In Use](../operations/monitoring-alerting.md#alert-expired-secret-in-use) |
| Quality | [TC-701](../quality/test-suites.md#tc-701-secrets-rotation--zero-downtime) through [TC-705](../quality/test-suites.md#tc-705-alert--service-using-expired-secret) |
| Confirmed by | Sasha Petrov (DevOps/SRE), 2025-10-10 |

**Verification:** 1/2 stories proven (US-014 — rotation without redeploy works for K8s services), 1 suspect (US-015 — audit trail records rotation events but cross-service consumption tracking not verified for non-K8s stacks). Last verified 2025-10-20.

---

## E8: PCI Compliance Gates

**Goal:** PCI-scoped services cannot deploy to production without security team sign-off, within a reasonable SLA.

**Origin:** Round 9 — PCI DSS v4.0 requires security team approval before every deploy to PCI-scoped services. Without this, the company loses PCI certification.

**Scope:**
- Approval workflow: deploy to PCI-scoped services requires security team sign-off
- Approval gate is reusable middleware — other compliance gates (HIPAA, SOX) can follow the same pattern
- 30-minute SLA on approvals — security team commits to respond within 30 min during business hours
- Auto-expire: if no response in 30 min, escalation path triggers (not auto-approve)

**Dependencies:** E4 (RBAC determines who can approve), E1 (deploy traceability for audit).

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-016](user-stories.md#us-016-pci-deploy-approval-workflow), [US-017](user-stories.md#us-017-30-minute-sla-on-approvals) |
| Decisions | [DEC-008](decision-log.md#dec-008-pci-gates-as-reusable-middleware-not-hard-coded) |
| Architecture | [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern), [ADR-014](../architecture/adrs.md#adr-014-pci-scope-tagging-in-pave-yaml) |
| Experience | [CLI: `pave deploy` approval prompt](../experience/cli-spec.md#pave-deploy--approval-required), [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue) |
| Quality | [TC-801](../quality/test-suites.md#tc-801-pci-deploy--approval-required-before-prod) through [TC-805](../quality/test-suites.md#tc-805-pci-approval--escalation-after-30-min) |
| Confirmed by | Marcus Chen (Platform Engineering Lead), 2025-11-05 |

**Verification:** 2/2 stories proven. Approval workflow tested end-to-end including escalation path. PCI auditor reviewed the gate design. Last verified 2025-11-15.

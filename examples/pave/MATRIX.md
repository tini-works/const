# Responsibility & Content Matrix

Who owns what. Who consumes what. Where to find what.

## Ownership matrix

> Column headers map to Constitution verticals: Product = PM, Experience = DX Design, Architecture = Engineer, Quality = QA, Operations = DevOps/SRE.

**O** = Owns (creates, maintains, reconciles) · **C** = Reads (matches against) · **N** = Notified (must acknowledge change + assess impact)

| Document | Product | Experience | Architecture | Quality | Operations |
|----------|---------|------------|--------------|---------|------------|
| **product/** | | | | | |
| [epics.md](product/epics.md) | **O** | C | C | C | N |
| [user-stories.md](product/user-stories.md) | **O** | C | C | C | N |
| [prd-canary-deploys.md](product/prd-canary-deploys.md) | **O** | C | C | N | N |
| [prd-multi-stack-onboarding.md](product/prd-multi-stack-onboarding.md) | **O** | C | C | N | C |
| [backlog.md](product/backlog.md) | **O** | C | C | C | C |
| [decision-log.md](product/decision-log.md) | **O** | C | C | C | C |
| [reconciliation-log.md](product/reconciliation-log.md) | **O** | N | N | N | N |
| **experience/** | | | | | |
| [cli-spec.md](experience/cli-spec.md) | C | **O** | C | C | N |
| [dashboard-specs.md](experience/dashboard-specs.md) | C | **O** | C | C | N |
| [onboarding-flows.md](experience/onboarding-flows.md) | C | **O** | C | C | N |
| [error-catalog.md](experience/error-catalog.md) | | **O** | C | C | N |
| [design-decisions.md](experience/design-decisions.md) | N | **O** | C | C | N |
| [reconciliation-log.md](experience/reconciliation-log.md) | N | **O** | N | N | N |
| **architecture/** | | | | | |
| [architecture.md](architecture/architecture.md) | N | C | **O** | C | C |
| [api-spec.md](architecture/api-spec.md) | | C | **O** | C | C |
| [data-model.md](architecture/data-model.md) | | | **O** | C | C |
| [adrs.md](architecture/adrs.md) | N | N | **O** | C | C |
| [tech-design-canary.md](architecture/tech-design-canary.md) | N | C | **O** | C | C |
| [tech-design-drift-detection.md](architecture/tech-design-drift-detection.md) | | | **O** | C | C |
| [tech-design-secrets-engine.md](architecture/tech-design-secrets-engine.md) | N | C | **O** | C | C |
| [tech-design-event-sourced-queue.md](architecture/tech-design-event-sourced-queue.md) | N | | **O** | C | C |
| [reconciliation-log.md](architecture/reconciliation-log.md) | N | N | **O** | N | N |
| **quality/** | | | | | |
| [test-plan.md](quality/test-plan.md) | C | C | C | **O** | C |
| [test-suites.md](quality/test-suites.md) | C | | C | **O** | C |
| [bug-reports.md](quality/bug-reports.md) | C | C | C | **O** | C |
| [coverage-report.md](quality/coverage-report.md) | C | C | C | **O** | N |
| [reconciliation-log.md](quality/reconciliation-log.md) | N | N | N | **O** | N |
| **operations/** | | | | | |
| [infrastructure.md](operations/infrastructure.md) | | | C | | **O** |
| [deployment-procedure.md](operations/deployment-procedure.md) | | | C | N | **O** |
| [monitoring-alerting.md](operations/monitoring-alerting.md) | N | | C | C | **O** |
| [environment-guide.md](operations/environment-guide.md) | | | C | C | **O** |
| [runbook-deploy-queue-corruption.md](operations/runbook-deploy-queue-corruption.md) | N | | C | N | **O** |
| [runbook-drift-detected.md](operations/runbook-drift-detected.md) | | | C | N | **O** |
| [runbook-canary-failure.md](operations/runbook-canary-failure.md) | | | C | N | **O** |
| [runbook-pave-outage.md](operations/runbook-pave-outage.md) | N | N | C | N | **O** |
| [runbook-secret-rotation-failure.md](operations/runbook-secret-rotation-failure.md) | | | C | N | **O** |
| [reconciliation-log.md](operations/reconciliation-log.md) | N | N | N | N | **O** |

## Content index

### product/ — what internal teams need from the platform

| File | Contains | Key IDs |
|------|----------|---------|
| [epics.md](product/epics.md) | 8 epics: deploy safety, canary, multi-stack onboarding, RBAC, platform resilience, deploy metrics, secrets, PCI gates | E1–E8 |
| [user-stories.md](product/user-stories.md) | 17 user stories + 3 bug stories with acceptance criteria | US-001–US-017, BUG-001–BUG-003 |
| [backlog.md](product/backlog.md) | Prioritized work with status and cross-links | — |
| [decision-log.md](product/decision-log.md) | 8 product decisions with context and rationale | DEC-001–DEC-008 |
| [prd-canary-deploys.md](product/prd-canary-deploys.md) | Full PRD: progressive rollout for all teams | — |
| [prd-multi-stack-onboarding.md](product/prd-multi-stack-onboarding.md) | Full PRD: onboarding Gridline (acquired startup, non-K8s stack) | — |
| [reconciliation-log.md](product/reconciliation-log.md) | Reconciliation events: what changed, what was re-verified | REC-001–REC-010 |

### experience/ — what engineers see and interact with

| File | Contains | Key IDs |
|------|----------|---------|
| [cli-spec.md](experience/cli-spec.md) | 20+ CLI commands: deploy, rollback, canary, secrets, init, audit, access | — |
| [dashboard-specs.md](experience/dashboard-specs.md) | 8 dashboard screens: deploy queue, service overview, canary monitor, audit log, health metrics, secrets, approvals, onboarding | D1–D8 |
| [onboarding-flows.md](experience/onboarding-flows.md) | 10 user journeys: standard deploy, rollback, emergency bypass, canary, onboarding, secrets, PCI approval, drift, permission denied, Pave-is-down | Flows 1–10 |
| [error-catalog.md](experience/error-catalog.md) | 22 error codes with remediation steps | PAVE-DEP-*, PAVE-CAN-*, PAVE-SEC-*, etc. |
| [design-decisions.md](experience/design-decisions.md) | 7 DX decisions: CLI-first, actionable errors, interactive wizard, comparison metrics, Slack approval, uncomfortable bypass, relative baselines | DD-001–DD-007 |
| [reconciliation-log.md](experience/reconciliation-log.md) | Reconciliation events: what changed, what was re-verified | — |

### architecture/ — how the platform works

| File | Contains | Key IDs |
|------|----------|---------|
| [architecture.md](architecture/architecture.md) | System decomposition: 8 services, data stores, security model | — |
| [api-spec.md](architecture/api-spec.md) | ~35 internal API endpoints with request/response shapes | — |
| [data-model.md](architecture/data-model.md) | 10 PostgreSQL tables with relationships and indexes | — |
| [adrs.md](architecture/adrs.md) | Architecture decisions: atomic deploys, drift detection, canary via Istio, pave.yaml schema, RBAC, event-sourced queue, deploy classification, Vault secrets, approval middleware | ADR-001+ |
| [tech-design-canary.md](architecture/tech-design-canary.md) | Istio VirtualService config, metric comparison, auto-rollback logic | — |
| [tech-design-drift-detection.md](architecture/tech-design-drift-detection.md) | Reconciliation loop, state fingerprinting, drift resolution workflow | — |
| [tech-design-secrets-engine.md](architecture/tech-design-secrets-engine.md) | Vault integration, sidecar injection, rotation flow | — |
| [tech-design-event-sourced-queue.md](architecture/tech-design-event-sourced-queue.md) | Event types, state derivation, recovery, migration from mutable table | — |
| [reconciliation-log.md](architecture/reconciliation-log.md) | Reconciliation events: what changed, what was re-verified | — |

### quality/ — what's proven, what's broken, what's risky

| File | Contains | Key IDs |
|------|----------|---------|
| [test-plan.md](quality/test-plan.md) | Testing strategy, scope, environments, priorities, exit criteria | — |
| [test-suites.md](quality/test-suites.md) | 58 test cases across 8 suites | TC-101–TC-806 |
| [bug-reports.md](quality/bug-reports.md) | 3 bugs: multi-commit blame, bypass overwrite, queue corruption | BUG-001–BUG-003 |
| [coverage-report.md](quality/coverage-report.md) | Story-to-test mapping, gaps, traceability completeness | — |
| [reconciliation-log.md](quality/reconciliation-log.md) | Reconciliation events: what changed, what was re-verified | — |

### operations/ — what's running, what to do when it breaks (including when Pave itself breaks)

| File | Contains | Key IDs |
|------|----------|---------|
| [infrastructure.md](operations/infrastructure.md) | Kubernetes deployment (pave-system), databases, Vault, S3, Istio, networking, DR | — |
| [deployment-procedure.md](operations/deployment-procedure.md) | Meta: Pave deploys itself + bootstrap procedure when Pave is down | — |
| [monitoring-alerting.md](operations/monitoring-alerting.md) | 15 monitors, 6 dashboards, alert rules, traceability to architecture/product/quality | — |
| [environment-guide.md](operations/environment-guide.md) | Local (minikube), staging, production setup with parity requirements | — |
| [runbook-deploy-queue-corruption.md](operations/runbook-deploy-queue-corruption.md) | Round 6 pattern: queue corruption diagnosis and recovery | — |
| [runbook-drift-detected.md](operations/runbook-drift-detected.md) | Drift assessment, resolution (accept or revert), PCI escalation | — |
| [runbook-canary-failure.md](operations/runbook-canary-failure.md) | Auto-rollback investigation, re-attempt strategy | — |
| [runbook-pave-outage.md](operations/runbook-pave-outage.md) | The meta runbook: when the deploy platform can't deploy | — |
| [runbook-secret-rotation-failure.md](operations/runbook-secret-rotation-failure.md) | Rotation failure by cause, manual rotation, service recovery | — |
| [reconciliation-log.md](operations/reconciliation-log.md) | Reconciliation events: what changed, what was re-verified | — |

## How to read the matrix

- **Start from your vertical.** Find the **O** column — those are your documents to maintain.
- **Follow C across.** Documents you read are your matching inputs. If they change, check if your matches still hold.
- **Follow N.** Notification means you must acknowledge the change and assess impact to your inventory. Unacknowledged notifications leave items suspect.
- **Traces, not chains.** Each item traces to what it matches. When something changes, its traces identify what needs re-verification — not through a linear chain, but through the web of matching decisions each team recorded.

## Timeline

The [timeline/](timeline/) directory contains 10 events (rounds 01–10) that drove all of this work. Read them to understand why each document exists.

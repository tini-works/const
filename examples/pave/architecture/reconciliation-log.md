# Reconciliation Log — Architecture Vertical

Changes triggered by incidents, new requirements, or cross-vertical shifts that required re-evaluation of architecture items.

---

## Entry 1: Multi-Commit Blame Failure (Round 1)

**Date:** 2025-06-20
**Trigger:** [BUG-001](../product/user-stories.md#bug-001-multi-commit-deploy-with-unknown-blame) — Team Falcon merged 3 PRs and deployed Friday at 5 PM. Checkout broke. 40 minutes to identify which commit caused it. Rollback was manual and painful.

**Impact assessment:** The entire deploy model was wrong. Multi-commit deploys made blame ambiguous and rollback a manual nightmare. Every deploy-related endpoint and data structure was suspect.

**Items re-evaluated:**
- Deploy data model: no commit-level traceability
- API: `POST /deploys` accepted branch deploys without commit SHA enforcement
- Rollback: no automated mechanism

**Items added/updated:**
- [ADR-001](adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy) created — one commit per deploy, atomic rollback
- `deploys` table: `commit_sha` made required, `rollback_target` added
- API: `POST /deploys` now requires `commit_sha`, rejects branch-only deploys
- API: `POST /deploys/{id}/rollback` created
- CLI spec: `pave deploy` and `pave rollback` commands defined

**Result:** Every deploy is exactly one commit. Rollback = redeploy previous commit. Blame is instant. No more Friday night forensics.

**Assessed by:** Kai Tanaka (Senior Platform Engineer)

---

## Entry 2: Canary Deploy (Round 3)

**Date:** 2025-08-01
**Trigger:** [US-004](../product/user-stories.md#us-004-canary-deploy-with-traffic-splitting), [US-005](../product/user-stories.md#us-005-auto-rollback-on-error-threshold) — Team Atlas requested progressive rollout. All-or-nothing deploys to payments were too risky.

**Impact assessment:** New component (Canary Controller), new Istio dependency, new data model (canary_sessions), new API endpoints. The deploy lifecycle expanded from a single step to a multi-phase process.

**Items re-evaluated:**
- Deploy lifecycle: was linear (queue → build → deploy → done), now branches for canary
- API: `POST /deploys` needed `canary` flag
- Data model: needed canary session tracking

**Items added/updated:**
- [ADR-003](adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) created — Istio VirtualService weighted routing
- [Tech design: canary](tech-design-canary.md) created
- `canary_sessions` table created
- API: canary endpoints added (Section 3)
- CLI: `pave deploy --canary`, `pave canary status/promote/abort` commands

**Suspect items:**
- Latency-based auto-rollback threshold: query written but trigger path untested (still suspect as of 2025-12-01)

**Result:** Teams can canary-deploy to a percentage of traffic, compare metrics, auto-promote or auto-rollback.

**Assessed by:** Kai Tanaka (Senior Platform Engineer)

---

## Entry 3: Bypass Overwrite Incident (Round 2)

**Date:** 2025-07-15
**Trigger:** [BUG-002](../product/user-stories.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix) — On-call engineer SSH'd to prod to fix a TLS cert at 2 AM. Monday morning, Pave deployed old code over the fix. Transactions failed for 20 minutes.

**Impact assessment:** Pave was blind to out-of-band changes. The expected-state model assumed Pave was the only entity modifying production. This assumption was wrong.

**Items re-evaluated:**
- Deploy Engine: deployed without checking if production state matched expectations
- No drift awareness anywhere in the system

**Items added/updated:**
- [ADR-002](adrs.md#adr-002-drift-detection-via-state-fingerprinting) created — drift detection via state fingerprinting
- [Tech design: drift detection](tech-design-drift-detection.md) created
- Drift Detector component added to architecture
- `drift_events` table created
- API: drift endpoints added (Section 4)
- Deploy pipeline: pre-deploy drift check added (pause if drift detected)

**Result:** Pave detects out-of-band changes within 5 minutes and pauses deploys until a human decides what to do. No more blind overwriting.

**Assessed by:** Sasha Petrov (DevOps/SRE)

---

## Entry 4: Gridline Onboarding (Round 4)

**Date:** 2025-08-15
**Trigger:** Epic [E3](../product/epics.md#e3-multi-stack-onboarding) — Gridline (acquired startup) needs to be on Pave within 90 days for SOC2. Their stack: Bash scripts, Docker Compose, no K8s.

**Impact assessment:** Architecture was K8s-only. Every component assumed Kubernetes. Gridline couldn't use Pave at all. Major gap.

**Items re-evaluated:**
- Deploy Engine: hardcoded K8s deployment logic
- Service registration: no concept of runtime
- Canary Controller: depends on Istio (K8s only)
- Drift Detector: depends on K8s API (K8s only)
- Secrets Engine (future): depends on sidecar injection (K8s only)

**Items added/updated:**
- [ADR-004](adrs.md#adr-004-pave-yaml-service-definition-schema) created — `pave.yaml` service definition schema
- [ADR-005](adrs.md#adr-005-adapter-pattern-for-multi-runtime-support) created — adapter pattern for multi-runtime
- `services` table: `runtime` column added
- Deploy Engine: refactored to use `DeployAdapter` interface
- `k8s-adapter` and `compose-adapter` implemented
- CLI: `pave init` and `pave validate` commands

**Gaps created:**
- Canary: not available for Docker Compose services
- Drift detection: not available for Docker Compose services
- Secrets injection: not available for Docker Compose services (confirmed in Round 8)

These gaps are documented in each component's section and in the [architecture overview](architecture.md#known-gaps-and-suspect-items).

**Result:** Gridline onboarded within 60 days. But they get a reduced feature set — no canary, no drift detection, no automated secrets rotation. Two-tier experience.

**Assessed by:** Kai Tanaka (Senior Platform Engineer)

---

## Entry 5: SOC2 RBAC + Audit (Round 5)

**Date:** 2025-09-01
**Trigger:** [US-008](../product/user-stories.md#us-008-full-deploy-audit-trail), [US-009](../product/user-stories.md#us-009-rbac-per-team-x-environment) — SOC2 audit found no access control. Every engineer could deploy anything anywhere. Intern deployed to prod.

**Impact assessment:** Every API endpoint was unauthenticated from an authorization perspective. Adding RBAC touched every endpoint's middleware. Adding audit log touched every state change.

**Items re-evaluated:**
- All API endpoints: needed RBAC check middleware
- All state-changing operations: needed audit log writes

**Items added/updated:**
- [ADR-006](adrs.md#adr-006-rbac-model--team-x-environment-matrix) created — team × environment RBAC
- [ADR-007](adrs.md#adr-007-immutable-audit-log-architecture) created — immutable audit log
- `roles` table created
- `audit_log` table created (append-only)
- API: RBAC endpoints added (Section 5), audit log endpoint added (Section 6)
- RBAC middleware added to all API endpoints
- Audit log writes added to all state-changing operations
- CLI: deploy permission denied error messages with remediation

**Result:** SOC2 finding resolved. Every deploy is attributable and authorized. Audit log covers all actions.

**Assessed by:** Kai Tanaka (Senior Platform Engineer), Sasha Petrov (DevOps/SRE)

---

## Entry 6: Deploy Queue Corruption (Round 6)

**Date:** 2025-09-15
**Trigger:** [BUG-003](../product/user-stories.md#bug-003-deploy-queue-corruption-during-rbac-migration) — Pave's own RBAC migration locked the deploy_queue table for 4 hours. Nobody could deploy. Three teams had P1 fixes queued.

**Impact assessment:** The mutable deploy queue was a single point of failure. Any migration or bug that touched the queue table blocked all deploys company-wide.

**Items re-evaluated:**
- Deploy queue: mutable `deploy_queue` table was the root cause
- All future Pave migrations: must be non-blocking

**Items added/updated:**
- [ADR-008](adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery) created — event-sourced deploy queue
- [ADR-009](adrs.md#adr-009-break-glass-bypass-procedure) created — break-glass bypass procedure
- [Tech design: event-sourced queue](tech-design-event-sourced-queue.md) created
- `deploy_events` table created (append-only)
- Old `deploy_queue` table dropped after 2-week migration
- API: queue management endpoints added (Section 10), bypass sync endpoint added (Section 11)
- CLI: `pave bypass` command created

**Suspect items:**
- Queue recovery during mid-write crash: tested with clean shutdown, not mid-write (still suspect as of 2025-12-01)

**Result:** Deploy queue is event-sourced and resilient to table locks. When Pave is down, teams can use break-glass bypass.

**Assessed by:** Kai Tanaka (Senior Platform Engineer)

---

## Entry 7: KPI Gaming → Deploy Classification (Round 7)

**Date:** 2025-10-01
**Trigger:** [US-012](../product/user-stories.md#us-012-deploy-health-dashboard), [US-013](../product/user-stories.md#us-013-deploy-classification), [DEC-006](../product/decision-log.md#dec-006-counter-propose-deploy-health-metrics-to-vp) — VP mandated deploy frequency KPI. Teams gamed it. Marcus counter-proposed deploy health metrics.

**Impact assessment:** New component (Metrics Collector), new field on deploys table, new API endpoints. Required integration with Git diff analysis.

**Items re-evaluated:**
- `deploys` table: no way to distinguish meaningful deploys from noise
- No metrics infrastructure

**Items added/updated:**
- [ADR-010](adrs.md#adr-010-deploy-classification-engine) created — automated classification
- Metrics Collector component added to architecture
- `deploys` table: `deploy_type` column added
- API: metrics endpoints added (Section 9)
- Dashboard: deploy health views

**Suspect items:**
- Config-only classification heuristic: untested against real-world config-only deploys

**Result:** Deploy frequency KPI replaced with deploy health metrics. Classification is automated — no gaming opportunity.

**Assessed by:** Kai Tanaka (Senior Platform Engineer)

---

## Entry 8: Secrets Rotation (Round 8)

**Date:** 2025-10-20
**Trigger:** [US-014](../product/user-stories.md#us-014-secrets-rotation-without-redeploy), [US-015](../product/user-stories.md#us-015-secrets-rotation-audit-trail) — Team Sentry's coordinated Redis credential rotation missed a service, causing 2 AM outage.

**Impact assessment:** Secrets were baked into images. Rotation required coordinated redeploys across services and teams. New component, new external dependency (Vault), new data model.

**Items re-evaluated:**
- Deploy Engine: secrets passed as build args / env vars
- No secrets management in Pave at all
- `pave.yaml` schema: needed `secrets` section

**Items added/updated:**
- [ADR-011](adrs.md#adr-011-runtime-secrets-injection-via-sidecar) created — Vault sidecar injection
- [ADR-012](adrs.md#adr-012-secrets-rotation-event-bus) created — rotation event tracking
- [Tech design: secrets engine](tech-design-secrets-engine.md) created
- Secrets Engine component added to architecture
- `secret_rotations` table created
- `pave.yaml` schema: `secrets` section added
- API: secrets endpoints added (Section 7)
- CLI: `pave secrets list`, `pave secrets rotate` commands

**Gaps confirmed:**
- Docker Compose services cannot use sidecar injection — manual rotation required for Gridline

**Result:** K8s services get zero-downtime secret rotation with audit trail. Compose services remain manual.

**Assessed by:** Sasha Petrov (DevOps/SRE), Kai Tanaka (Senior Platform Engineer)

---

## Entry 9: PCI Approval Gates (Round 9)

**Date:** 2025-11-15
**Trigger:** [US-016](../product/user-stories.md#us-016-pci-deploy-approval-workflow), [US-017](../product/user-stories.md#us-017-30-minute-sla-on-approvals) — PCI DSS v4.0 requires security team sign-off before every deploy to PCI-scoped services.

**Impact assessment:** New component (Approval Service), new pipeline stage, new data model. The deploy pipeline changed from linear to branching (approval gate inserts conditionally). `pave.yaml` schema extended.

**Items re-evaluated:**
- Deploy pipeline: was linear, needed conditional stage insertion
- `pave.yaml` schema: needed `pci_scoped` flag
- Notification Service: needed approval notification support
- `services` table: needed `pci_scoped` column

**Items added/updated:**
- [ADR-013](adrs.md#adr-013-approval-gate-middleware-pattern) created — approval as pipeline middleware
- [ADR-014](adrs.md#adr-014-pci-scope-tagging-in-pave-yaml) created — PCI scope in `pave.yaml`
- Approval Service component added to architecture
- `approvals` table created
- `services` table: `pci_scoped` column added
- `pave.yaml` schema: `pci_scoped` flag added
- API: approval endpoints added (Section 8)
- Slack integration: approval request/response via Slack actions
- CLI: `pave deploy` shows approval status for PCI services

**Result:** PCI-scoped services require security team approval before prod deploys. 30-min SLA with escalation. PCI auditor confirmed compliance.

**Assessed by:** Kai Tanaka (Senior Platform Engineer)

---

## Entry 10: Experience Vertical Feedback on Error Messages

**Date:** 2025-10-10
**Trigger:** [DX Design Review](../experience/design-decisions.md) — Rina Okafor (DX Designer) reviewed API error responses and found they were inconsistent and unhelpful. Error codes existed but remediation steps were missing.

**Impact assessment:** Every API error response needed review. Not a data model or architecture change, but a cross-cutting API contract change.

**Items re-evaluated:**
- All API error responses: inconsistent structure, no remediation guidance
- CLI error messages: just printed raw API errors

**Items added/updated:**
- Standardized error response format across all endpoints:
  ```json
  { "error": "error_code", "message": "human-readable", "remediation": "what to do" }
  ```
- [Error catalog](../experience/error-catalog.md) cross-referenced with API spec
- API spec: all error responses updated to include `remediation` field

**Result:** Every API error includes a remediation step. CLI renders them as actionable messages, not stack traces.

**Assessed by:** Kai Tanaka (Senior Platform Engineer), Rina Okafor (DX Designer)

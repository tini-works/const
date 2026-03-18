# Decision Log

## DEC-001: Every deploy is exactly one commit
**Date:** 2025-06-10 (Round 1)
**Context:** Team Falcon merged 3 PRs into one deploy on Friday at 5 PM. Checkout broke. 40 minutes to figure out which commit caused it. Rollback was manual because there was no clear "previous known good state" — just a bundle of changes.
**Options considered:**
1. Recommend (but don't enforce) single-commit deploys via documentation
2. Enforce atomic single-commit deploys at the API level — multi-commit payloads are rejected
3. Allow multi-commit deploys but auto-tag each commit for easier blame
**Decision:** Option 2 — enforce at the API level. One commit per deploy, no exceptions.
**Rationale:** Recommendations don't work when it's Friday at 5 PM and the team just wants to ship. Tagging commits for blame is a half-measure — you still need to roll back the whole bundle. Atomic deploys make blame instant and rollback precise. The trade-off is that teams must deploy more frequently (which is the behavior we want anyway). Teams that batch to reduce deploy overhead are revealing a real friction we need to fix in the pipeline speed, not in the deploy model.

**Traceability:**
- Traced from: Round 1 — Team Falcon Friday deploy incident (3 PRs batched, 40-min outage)
- Matched by: [US-001](user-stories.md#us-001-atomic-single-commit-deploys), [BUG-001](user-stories.md#bug-001-multi-commit-deploy-with-unknown-blame), [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy)
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-06-10

---

## DEC-002: Detect drift, not just prevent bypass
**Date:** 2025-06-25 (Round 2)
**Context:** Team Kite's on-call SSH'd to prod at 2 AM Saturday to fix a TLS cert. Legitimate emergency. Monday morning, Pave deployed old code over the fix. 20 minutes of lost payment transactions. The problem isn't that someone bypassed Pave — sometimes they have to. The problem is that Pave didn't know.
**Options considered:**
1. Block all non-Pave access to production (network-level enforcement)
2. Detect drift — Pave periodically fingerprints prod and flags divergence from expected state
3. Accept drift as inevitable and document "always redeploy after SSH"
**Decision:** Option 2 — drift detection.
**Rationale:** Blocking all non-Pave access is operationally dangerous — it means Pave being down also blocks emergency fixes (Round 6 proved this fear correct). Documenting "always redeploy" is a process solution to a systems problem — people forget. Drift detection is the mature answer: Pave continuously knows what state prod is in, and warns when it doesn't match. If someone SSH'd in, Pave knows before the next deploy and forces the deployer to reconcile.

**Traceability:**
- Traced from: Round 2 — Team Kite bypass overwrite incident (manual hotfix reverted by Pave)
- Matched by: [US-003](user-stories.md#us-003-drift-detection), [BUG-002](user-stories.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix), [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting)
- Confirmed by: Sasha Petrov (DevOps/SRE), 2025-06-25

---

## DEC-003: Canary available to all teams, not just payments
**Date:** 2025-07-05 (Round 3)
**Context:** Team Atlas (payments) requested canary deploys. They handle financial transactions and want to validate changes against live traffic before full rollout. Question: do we build canary as a payments-specific feature or as a platform-wide capability?
**Options considered:**
1. Canary only for payments team (Team Atlas) — scoped and fast to build
2. Canary as a platform feature available to all teams
3. Canary as opt-in, but only for teams that meet a readiness criteria (health checks, monitoring)
**Decision:** Option 2 — available to all teams.
**Rationale:** Every team deploying to production has the same risk profile at different scales. Payments just feels it more because the blast radius is financial. If canary is useful for payments, it's useful for checkout, for user accounts, for search. Building it as a payments-only feature means we build it twice when the next team asks. Platform features should be platform-wide. The only prerequisite is that the service has a health check endpoint — which `pave.yaml` already requires.

**Traceability:**
- Traced from: Round 3 — Team Atlas canary deploy request
- Matched by: [US-004](user-stories.md#us-004-canary-deploy-with-traffic-splitting), [US-005](user-stories.md#us-005-auto-rollback-on-error-threshold), [E2](epics.md#e2-progressive-rollout), [PRD: Canary Deploys](prd-canary-deploys.md), [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting)
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-07-05

---

## DEC-004: Onboarding via service definition schema, not custom integrations
**Date:** 2025-07-20 (Round 4)
**Context:** Gridline (acquired startup, 30 people) needs to onboard to Pave within 90 days for SOC2. They run Bash + Docker Compose. We could build a custom Gridline adapter or define a universal schema that any team can use.
**Options considered:**
1. Build a custom adapter for Gridline's Docker Compose setup
2. Define a `pave.yaml` schema as the universal service definition — all teams declare their service, Pave adapts to the runtime
3. Require Gridline to migrate to K8s first, then onboard to standard Pave
**Decision:** Option 2 — universal schema (`pave.yaml`).
**Rationale:** A custom adapter solves Gridline but creates a maintenance burden for every unique setup. Requiring K8s migration first would blow the 90-day SOC2 deadline and is the wrong sequencing — deploy governance is more urgent than runtime modernization. `pave.yaml` as a universal contract means any team describes what they have, and Pave figures out how to deploy it. The schema becomes the onboarding interface for every future team, not just Gridline.

**Traceability:**
- Traced from: Round 4 — Gridline acquisition, 90-day SOC2 deadline
- Matched by: [US-006](user-stories.md#us-006-compatibility-mode-for-non-k8s-stacks), [US-007](user-stories.md#us-007-service-definition-schema--paveyaml), [E3](epics.md#e3-multi-stack-onboarding), [PRD: Multi-Stack Onboarding](prd-multi-stack-onboarding.md), [ADR-004](../architecture/adrs.md#adr-004-pave-yaml-service-definition-schema), [ADR-005](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support)
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-07-20

---

## DEC-005: RBAC at team x environment granularity
**Date:** 2025-08-05 (Round 5)
**Context:** SOC2 audit found zero access controls. Every engineer can deploy any service to any environment. An intern on Team Bolt deployed to production twice. Auditor flagged this as a critical finding.
**Options considered:**
1. Per-individual permissions (each person gets explicit access grants)
2. Team x environment matrix (Team Falcon can deploy their services to staging; only leads can deploy to prod)
3. Environment-only restrictions (anyone can deploy to staging, only senior engineers can deploy to prod)
**Decision:** Option 2 — team x environment matrix.
**Rationale:** Per-individual is an admin nightmare at 300 engineers — every new hire, every team transfer, every role change requires manual permission updates. Environment-only doesn't prevent cross-team accidents (Team A deploying Team B's service). Team x environment gives us the right granularity: teams own their services, and the prod/staging boundary is a natural trust threshold. Role hierarchy (viewer -> deployer -> lead -> admin) keeps it simple. Team ownership is sourced from GitHub Teams, so we're not maintaining a separate directory.

**Traceability:**
- Traced from: Round 5 — SOC2 audit finding + Team Bolt intern incident
- Matched by: [US-008](user-stories.md#us-008-full-deploy-audit-trail), [US-009](user-stories.md#us-009-rbac-per-team-x-environment), [E4](epics.md#e4-access-control--audit), [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix)
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-08-05

---

## DEC-006: Counter-propose deploy health metrics to VP
**Date:** 2025-09-15 (Round 7)
**Context:** VP Amy Nakamura mandated "10 deploys per team per week" as a velocity KPI. Within 2 weeks, teams gamed it: split PRs into trivial pieces, deployed README changes, pushed config tweaks as separate deploys. Deploy frequency tripled. Failure rate tripled.
**Options considered:**
1. Comply — enforce the 10-deploy target and let teams figure out how
2. Push back with data — show VP that the metric is being gamed and propose alternatives
3. Silently ignore the mandate and hope VP doesn't follow up
**Decision:** Option 2 — push back with data. Marcus brought VP three weeks of data: deploy frequency vs. failure rate, showing both tripled in lockstep. Proposed replacement metrics: deploy success rate, MTTR, change failure rate, lead time (DORA-aligned). VP agreed to a 90-day trial.
**Rationale:** Complying with a bad metric is worse than having no metric — it incentivizes exactly the wrong behavior and erodes trust in platform data. Ignoring the VP is politically suicidal. The only sustainable path is to educate with evidence and propose something better. DORA metrics are industry-standard, battle-tested, and much harder to game.

**Traceability:**
- Traced from: Round 7 — VP deploy frequency mandate, gaming behavior observed
- Matched by: [US-012](user-stories.md#us-012-deploy-health-dashboard), [US-013](user-stories.md#us-013-deploy-classification), [E6](epics.md#e6-meaningful-deploy-metrics), [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine)
- Confirmed by: VP Amy Nakamura (VP Engineering), 2025-09-20

---

## DEC-007: Secrets rotation is platform responsibility
**Date:** 2025-10-01 (Round 8)
**Context:** Team Sentry rotates Redis creds every 90 days. Requires coordinated deploys of 6 services. Last time, one service missed the memo and went down at 2 AM. Every team with shared secrets has this problem. Question: should each team manage their own rotation, or should the platform own it?
**Options considered:**
1. Teams manage their own secrets and coordinate rotation themselves
2. Platform provides secrets injection and rotation as a built-in capability
3. Adopt a third-party secrets manager (Vault, AWS Secrets Manager) and let teams integrate directly
**Decision:** Option 2 — platform provides it.
**Rationale:** Team-managed rotation is the status quo and it clearly doesn't work — coordination across 6 teams for a single secret is error-prone and unscalable. Third-party secrets managers are powerful but put the integration burden on every team individually, which means 20 teams doing 20 different integrations. The platform already controls the deploy pipeline and the runtime environment — secrets injection is a natural extension. Pave injects secrets at runtime via sidecar, rotates them centrally, and tracks consumption. Individual teams don't need to know when or how secrets rotate — they just work.

**Traceability:**
- Traced from: Round 8 — Team Sentry secrets rotation incident (6 services, 1 missed, 2 AM outage)
- Matched by: [US-014](user-stories.md#us-014-secrets-rotation-without-redeploy), [US-015](user-stories.md#us-015-secrets-rotation-audit-trail), [E7](epics.md#e7-secrets-management), [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus)
- Confirmed by: Sasha Petrov (DevOps/SRE), 2025-10-05

---

## DEC-008: PCI gates as reusable middleware, not hard-coded
**Date:** 2025-10-20 (Round 9)
**Context:** PCI DSS v4.0 requires security team sign-off before every deploy to PCI-scoped services. We could hard-code a PCI check into the deploy pipeline, or build a general-purpose approval gate that PCI is the first user of.
**Options considered:**
1. Hard-code PCI approval check in the deploy pipeline (if service is PCI-scoped, require security sign-off)
2. Build a reusable approval gate middleware — PCI is the first policy, but HIPAA, SOX, or custom gates can follow the same pattern
3. Use an external approval tool (Jira, ServiceNow) and integrate via webhook
**Decision:** Option 2 — reusable middleware.
**Rationale:** Hard-coding works for PCI but becomes spaghetti when HIPAA or SOX requirements arrive (and they will — the company is growing). External tools add latency and another system to maintain. A middleware pattern means the deploy pipeline has a generic "gate" concept: before this deploy proceeds, these conditions must be met. PCI is one gate policy. Future compliance needs just add new policies without changing the pipeline core. The `pave.yaml` schema tags services with their compliance scope (`pci: true`, `hipaa: true`), and the pipeline applies the appropriate gates.

**Traceability:**
- Traced from: Round 9 — PCI DSS v4.0 deploy approval requirement
- Matched by: [US-016](user-stories.md#us-016-pci-deploy-approval-workflow), [US-017](user-stories.md#us-017-30-minute-sla-on-approvals), [E8](epics.md#e8-pci-compliance-gates), [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern), [ADR-014](../architecture/adrs.md#adr-014-pci-scope-tagging-in-pave-yaml)
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-10-25

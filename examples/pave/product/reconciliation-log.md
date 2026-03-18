# Reconciliation Log

Running record of change events that triggered impact assessment and re-verification of PM inventory items.

---

## REC-001: Friday Deploy Incident — Team Falcon Breaks Checkout

**Date:** 2025-06-10
**Change/trigger:** Round 1 — Team Falcon merged 3 PRs and deployed at 5 PM Friday. Checkout broke. 40 minutes to identify which commit caused it. Rollback was manual.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Kai Tanaka (Senior Platform Engineer)

**Impact assessment:**
- Deploy model is fundamentally broken — batching commits makes blame impossible and rollback slow
- Manual rollback takes too long — 40 minutes of downtime for a checkout flow is unacceptable
- This will happen again unless the pipeline enforces atomicity

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E1 | Created — Deploy Safety & Traceability epic | Scope: atomic deploys, instant rollback, deploy traceability. |
| US-001 | Created — atomic single-commit deploys | 4 AC including API-level enforcement of one commit per deploy. |
| US-002 | Created — instant rollback under 2 minutes | 5 AC including automated rollback without SSH. |
| BUG-001 | Created — multi-commit deploy with unknown blame | P1 bug — existing multi-commit behavior is the root cause. |
| DEC-001 | Created — every deploy is exactly one commit | Enforced at API, not advisory. |
| Backlog | Initialized — BUG-001 at P1, US-001/US-002 at P2 | Fix the root cause first, then build the safety net. |

---

## REC-002: Bypass Overwrite — Team Kite's Manual Fix Reverted

**Date:** 2025-06-25
**Change/trigger:** Round 2 — Team Kite's on-call SSH'd to prod Saturday at 2 AM to fix a TLS cert. Legitimate emergency. Monday, Pave deployed old code over the fix. 20 minutes of lost payment transactions.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Sasha Petrov (DevOps/SRE)

**Impact assessment:**
- Pave is blind to production state — it doesn't know when someone changes prod outside the pipeline
- Blocking all non-Pave access is operationally dangerous (what if Pave is down?)
- The correct response is awareness, not prevention — Pave needs to know when prod drifts

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| US-003 | Created — drift detection | 5 AC including periodic fingerprinting, deploy-time warning, and audit logging. |
| BUG-002 | Created — bypass overwrite bug | P1 — Pave silently reverted a valid manual change. |
| DEC-002 | Created — detect drift, not just prevent bypass | Drift detection is the mature answer — awareness over blocking. |
| E1 scope | Updated — added drift detection to E1 | E1 now covers: atomic deploys + instant rollback + drift detection. |
| US-002 | Reviewed — rollback must not overwrite acknowledged drift | Confirmed: rollback targets the known-good state, not just "previous deploy." |

---

## REC-003: Canary Deploy Request — Team Atlas (Payments)

**Date:** 2025-07-05
**Change/trigger:** Round 3 — Team Atlas (payments) requests canary deploys. They want to route 5% of traffic to a new version, validate error rates, then roll forward. Payments team argues they can't afford another full-rollout failure.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Kai Tanaka (Senior Platform Engineer)

**Impact assessment:**
- Canary is a valid risk mitigation for any team, not just payments
- Requires traffic splitting at the infrastructure level — significant engineering effort
- Auto-rollback on error threshold is the real value — manual monitoring defeats the purpose

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E2 | Created — Progressive Rollout epic | Scope: canary with traffic splitting, auto-rollback, available to all teams. |
| US-004 | Created — canary deploy with traffic splitting | 6 AC covering percentage config, real-time metrics, manual promote/cancel. |
| US-005 | Created — auto-rollback on error threshold | 6 AC covering error rate and latency thresholds, notification, audit. |
| DEC-003 | Created — canary available to all teams | Platform features should be platform-wide, not team-specific. |
| PRD: Canary Deploys | Created — full PRD | Problem, solution, requirements, dependencies, risks. |
| E1 | Reviewed — rollback mechanism is shared between E1 and E2 | Confirmed: E2 depends on E1 rollback infrastructure. |

---

## REC-004: Gridline Acquisition — Non-K8s Team Must Onboard

**Date:** 2025-07-20
**Change/trigger:** Round 4 — Gridline (acquired startup, 30 people, Bash + Docker Compose, no K8s) must be on Pave within 90 days for SOC2. Pave currently only supports K8s workloads.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Rina Okafor (Developer Experience Designer)

**Impact assessment:**
- Pave's K8s-only assumption is a hard blocker for Gridline
- Requiring K8s migration first would blow the 90-day deadline
- If we solve this for Gridline, we solve it for any future non-K8s team
- Need a universal service definition schema to decouple deploy governance from runtime

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E3 | Created — Multi-Stack Onboarding epic | Scope: non-K8s compatibility, `pave.yaml` schema, guided onboarding. |
| US-006 | Created — compatibility mode for non-K8s stacks | 5 AC covering Docker Compose, ECS, and runtime abstraction. |
| US-007 | Created — service definition schema (`pave.yaml`) | 5 AC covering schema, validation, scaffolding, versioning. |
| DEC-004 | Created — schema, not custom integrations | Universal schema is better than per-team adapters. |
| PRD: Multi-Stack Onboarding | Created — full PRD | Gridline as primary user, generalizable to future teams. |
| US-003 (E1) | Reviewed — drift detection must work for non-K8s too | Gap flagged: drift detection fingerprinting assumes K8s. Needs adapter extension. |
| US-002 (E1) | Reviewed — rollback must work for Docker Compose | Confirmed: rollback adapter needed for non-K8s runtimes. |

---

## REC-005: SOC2 Audit — No RBAC, Intern Deployed to Prod

**Date:** 2025-08-05
**Change/trigger:** Round 5 — SOC2 audit found zero access controls. Every engineer can deploy any service to any environment. An intern on Team Bolt deployed to production twice. Auditor flagged it as a critical finding.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Dani Reeves (QA Lead)

**Impact assessment:**
- SOC2 critical finding — must remediate before next audit cycle
- Intern incident is embarrassing but not the real risk — the real risk is any engineer deploying any team's service
- RBAC is also a prerequisite for PCI compliance (which is coming)
- Must be careful that RBAC implementation doesn't create a new single point of failure

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E4 | Created — Access Control & Audit epic | Scope: audit trail + RBAC at team x environment granularity. |
| US-008 | Created — full deploy audit trail | AC covers SOC2 requirements: actor, timestamp, service, env, outcome, retention. |
| US-009 | Created — RBAC per team x environment | AC covers role hierarchy, permission checks at API level, GitHub Teams integration. |
| DEC-005 | Created — RBAC at team x environment granularity | Team x environment matrix is the right granularity for 300 engineers. |
| E3 (Gridline) | Reviewed — Gridline teams need RBAC from day one | Confirmed: E4 is dependency for E3. Can't onboard without access controls. |
| Backlog | Reprioritized — US-008/US-009 elevated | SOC2 remediation timeline drives priority. |

---

## REC-006: RBAC Migration Breaks Deploy Queue — 4-Hour Outage

**Date:** 2025-09-05
**Change/trigger:** Round 6 — Adding RBAC tables, migration bug took a lock on deploy_queue for 4 hours. Nobody could deploy. Three teams had P1 fixes queued. The thing we built to make deploys safer made deploys impossible.
**Assessed by:** Kai Tanaka (Senior Platform Engineer), Sasha Petrov (DevOps/SRE)

**Impact assessment:**
- Pave itself became the bottleneck — exactly the criticism teams have been making
- No bypass procedure existed — teams were trapped
- DB migration strategy is broken — long-running migrations can't lock production tables
- Queue must be resilient to internal failures

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E5 | Created — Platform Resilience epic | Scope: break-glass bypass, queue resilience, self-healing. |
| US-010 | Created — manual bypass when Pave is down | 5 AC including documented procedure, two-person auth, retroactive audit. |
| US-011 | Created — deploy queue resilience | 5 AC covering WAL-based recovery, non-blocking migrations, stall alerting. |
| BUG-003 | Created — deploy queue corruption | P0 — 4-hour outage is a platform credibility crisis. |
| DEC-002 (E1) | Reviewed — drift detection justification strengthened | This incident validates "detect, don't block." If we'd blocked all non-Pave access, these 3 teams would have had zero recourse. |
| E4 | Reviewed — future RBAC changes must be non-blocking | Added constraint: all Pave DB migrations must be online/non-blocking. |

---

## REC-007: VP Mandates Deploy Frequency KPI — Gaming Ensues

**Date:** 2025-09-15
**Change/trigger:** Round 7 — VP Amy Nakamura mandated "10 deploys per team per week." Within 2 weeks, teams gamed it: split PRs, deployed README changes. Frequency tripled, failure rate tripled. The metric created the opposite of the intended behavior.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Rina Okafor (Developer Experience Designer)

**Impact assessment:**
- Vanity metrics actively harm engineering culture — teams optimize for the metric, not the outcome
- Raw frequency is trivially gameable and Pave's data proves it
- Marcus needs to push back with evidence, not just opinion — political risk but necessary
- This is also an opportunity to build meaningful metrics into the platform

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E6 | Created — Meaningful Deploy Metrics epic | Scope: health dashboard, deploy classification, DORA-aligned metrics. |
| US-012 | Created — deploy health dashboard | 5 AC covering success rate, MTTR, change failure rate, lead time. |
| US-013 | Created — deploy classification | 5 AC covering automatic tagging, override, exclusion from metrics. |
| DEC-006 | Created — counter-propose health metrics to VP | Marcus brought 3 weeks of data to VP. VP agreed to 90-day trial of DORA metrics. |
| E4 (Audit) | Reviewed — audit data feeds metrics engine | Confirmed: deploy audit trail is the data source for metrics calculation. |
| E1 (Traceability) | Reviewed — deploy traceability feeds classification | Confirmed: commit metadata from atomic deploys enables automatic classification. |

---

## REC-008: Secrets Rotation Incident — 6 Services, 1 Missed

**Date:** 2025-10-01
**Change/trigger:** Round 8 — Team Sentry rotates Redis creds every 90 days. Requires coordinated deploys of 6 services. One service missed. Went down at 2 AM. 45 minutes to diagnose which service was still on old creds.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Sasha Petrov (DevOps/SRE)

**Impact assessment:**
- Coordinated rotation is a fundamentally flawed pattern — it doesn't scale and humans forget
- Secrets should be injected at runtime, not baked into deploy artifacts
- Platform already controls the runtime environment — secrets injection is a natural extension
- Non-K8s stacks (Gridline) need secrets too

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E7 | Created — Secrets Management epic | Scope: runtime injection, rotation without redeploy, consumption tracking, audit. |
| US-014 | Created — secrets rotation without redeploy | 5 AC covering sidecar injection, 60-second pickup, atomic rotation. |
| US-015 | Created — secrets rotation audit trail | 5 AC covering rotation events, per-service consumption, compliance flagging. |
| DEC-007 | Created — secrets rotation is platform responsibility | Platform owns injection and rotation. Teams don't coordinate. |
| E3 (Multi-Stack) | Reviewed — secrets injection must work for non-K8s | Gap flagged: sidecar pattern assumes K8s. Need Docker Compose equivalent (env file injection?). |
| E4 (RBAC) | Reviewed — RBAC applies to secrets access | Confirmed: who can rotate which secrets follows the team x environment model. |

---

## REC-009: PCI DSS v4.0 Deploy Approval Requirement

**Date:** 2025-10-20
**Change/trigger:** Round 9 — PCI DSS v4.0 requires security team sign-off before every deploy to PCI-scoped services. Without this, the company loses PCI certification. Affects Team Atlas (payments) and any team touching cardholder data.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Dani Reeves (QA Lead)

**Impact assessment:**
- Non-negotiable compliance requirement — PCI certification is a business prerequisite for payments
- Gate must not become a bottleneck — if security team is slow, deploys pile up
- This won't be the last compliance gate — HIPAA and SOX are coming
- Build as generic middleware, not hard-coded PCI logic

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E8 | Created — PCI Compliance Gates epic | Scope: approval workflow, SLA enforcement, reusable middleware pattern. |
| US-016 | Created — PCI deploy approval workflow | 6 AC covering approval gate, notification, approve/reject flow, immutable record. |
| US-017 | Created — 30-minute SLA on approvals | 6 AC covering notification, escalation at 30/60 min, SLA tracking, no auto-approve. |
| DEC-008 | Created — PCI gates as reusable middleware | Middleware pattern enables future HIPAA/SOX gates without pipeline changes. |
| US-007 (E3) | Reviewed — `pave.yaml` must support compliance tags | Updated: schema adds `compliance` section with `pci`, `hipaa`, `sox` boolean flags. |
| E4 (RBAC) | Reviewed — who can approve? | Confirmed: approver role added to RBAC matrix. Security team members get approver role for PCI-scoped services. |

---

## REC-010: CTO Proposes Replacing Pave — Evidence Required

**Date:** 2025-11-20
**Change/trigger:** Round 10 — CTO James Liu asks: "Why shouldn't we buy Humanitec or adopt Backstage? What has Pave actually delivered that we couldn't get off the shelf?" This is not a hostile question — it's a reasonable one. The platform team must justify Pave's existence with evidence, not assertion.
**Assessed by:** Marcus Chen (Platform Engineering Lead), Kai Tanaka (Senior Platform Engineer), Dani Reeves (QA Lead)

**Impact assessment:**
- Existential threat to the platform team — if Pave can't demonstrate value, it gets replaced
- This is the ultimate test of the CONST model: proof requires evidence, not assertion
- Every epic must produce measurable evidence of impact
- Some evidence will be strong, some will have gaps — that's honest

**Items reevaluated:**

| Item | Action | Result |
|------|--------|--------|
| E1 | Reviewed — evidence of value | **Strong:** Deploy blame time reduced from 40 min to instant. Rollback from manual (40 min) to automated (47 sec). Drift detection caught 3 unauthorized changes in last quarter. |
| E2 | Reviewed — evidence of value | **Moderate:** 8 teams using canary. 4 auto-rollbacks prevented outages. But latency-based threshold still untested (US-005 suspect). |
| E3 | Reviewed — evidence of value | **Moderate:** Gridline onboarded in 67 days (under 90-day target). 12 teams total on Pave. But ECS adapter still missing — 2 teams waiting. |
| E4 | Reviewed — evidence of value | **Strong:** SOC2 audit passed. Zero unauthorized deploys since RBAC launch. Audit log used in 2 incident investigations. |
| E5 | Reviewed — evidence of value | **Moderate:** Bypass procedure used once successfully. Queue hasn't corrupted since fix. But chaos testing for mid-write crash not done (US-011 suspect). |
| E6 | Reviewed — evidence of value | **Strong:** VP adopted DORA metrics. Gaming behavior stopped. Change failure rate dropped 40% in 90-day trial. But classification heuristic has gaps (US-013 suspect). |
| E7 | Reviewed — evidence of value | **Moderate:** Redis rotation for Team Sentry now zero-coordination. But non-K8s secrets injection untested (US-015 suspect). |
| E8 | Reviewed — evidence of value | **Strong:** PCI audit passed. Approval SLA at 92%. No auto-approve escape hatch. |
| Overall | Assessment prepared for CTO | 4 epics have strong evidence, 4 have moderate evidence with identified gaps. No epic has no evidence. Gaps are documented honestly. Pave solves problems Humanitec/Backstage don't: drift detection, atomic deploys, deploy classification, PCI gates tailored to our compliance. Off-the-shelf tools would need significant customization to match. |
| Backlog | No new items — but suspect items reprioritized | Gaps surfaced by this review (US-005 latency threshold, US-011 chaos testing, US-013 classification coverage, US-015 non-K8s secrets) moved up in priority. Evidence gaps are now credibility risks. |

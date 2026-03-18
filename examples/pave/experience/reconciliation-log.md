# Reconciliation Log — Developer Experience

Tracks when changes in other verticals (product, architecture, operations) required re-evaluation of DX artifacts. Each entry records what changed, what was impacted, and the outcome.

---

## Entry 1: Round 1 Incident — Rollback UX and Commit Visibility

**Date:** 2025-06-15
**Change:** Round 1 post-mortem — 3 PRs deployed together, 40 min to find blame. Rollback command was obscure. Engineers couldn't tell which commits were in a deploy. Product created [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility) (commit visibility) and [US-002](../product/user-stories.md#us-002-deploy-rollback) (clear rollback).

**Impact on DX:**
- CLI spec: `pave deploy` output redesigned to show commit list with authors and timestamps
- CLI spec: `pave rollback` redesigned with clear current/target display and mandatory `--reason` for production
- CLI spec: `pave status` shows current deploy version, deployer, and error rate
- Error catalog: PAVE-DEP-008 (rollback target not found) added

**Items reevaluated:**
- cli-spec.md: Sections 1.1 (deploy), 1.2 (rollback), 1.3 (status) created
- error-catalog.md: PAVE-DEP-001 through PAVE-DEP-005 created
- onboarding-flows.md: Flow 1 (standard deploy) and Flow 2 (deploy with rollback) created

**Result:** Every deploy shows exactly which commits are included. Rollback shows the target version's history ("ran 23h without issues") as a confidence signal.

**Assessed by:** Rina Okafor (DX Designer), 2025-06-15

---

## Entry 2: Round 2 Bypass — Emergency Deploy Path and Drift UX

**Date:** 2025-07-01
**Change:** Team Kite SSH'd to prod to fix a TLS cert. Pave overwrote the fix on next deploy. Product created [US-003](../product/user-stories.md#us-003-drift-detection-after-manual-changes) (drift detection) and [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass) (emergency bypass). Architecture introduced [Drift Detector](../architecture/architecture.md#drift-detector).

**Impact on DX:**
- CLI spec: `pave drift show` command created — shows what changed, when, and remediation options
- CLI spec: `pave emergency deploy` command created with `--acknowledge-audit` required flag
- Error catalog: PAVE-DFT-001 (drift detected — deploy blocked) added
- Design decision DD-006 created: emergency bypass is possible but uncomfortable
- Onboarding flows: Flow 3 (emergency deploy) and Flow 8 (drift detection) created

**Items reevaluated:**
- cli-spec.md: Sections 7 (drift) and 8 (emergency) created
- error-catalog.md: PAVE-DFT-001 added
- design-decisions.md: DD-006 added
- onboarding-flows.md: Flows 3 and 8 created

**Result:** Engineers have an official bypass path that's auditable. Drift is surfaced with clear context, not blamed. The error message for drift says "drift detected" not "unauthorized change."

**Assessed by:** Rina Okafor (DX Designer), 2025-07-01

---

## Entry 3: Round 3 Canary — CLI and Dashboard for Progressive Rollout

**Date:** 2025-07-25
**Change:** Team Atlas requested canary deploys for payments service. Product created [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys). Architecture introduced [Canary Controller](../architecture/architecture.md#canary-controller) and canary API endpoints.

**Impact on DX:**
- CLI spec: Full canary command suite created — `pave canary start`, `promote`, `abort`
- Dashboard spec: D3 (Canary Monitor) created — side-by-side baseline vs canary metrics
- Design decision DD-004 created: canary dashboard shows comparison metrics, not just canary
- Error catalog: PAVE-CAN-001 through PAVE-CAN-003 added
- Onboarding flows: Flow 4 (canary deploy lifecycle) created

**Items reevaluated:**
- cli-spec.md: Section 2 (canary commands) created
- dashboard-specs.md: D3 (Canary Monitor) created
- error-catalog.md: PAVE-CAN-* errors added
- design-decisions.md: DD-004 added
- onboarding-flows.md: Flow 4 created

**Result:** Complete canary lifecycle through both CLI and dashboard. Side-by-side comparison layout is non-negotiable — you can't evaluate a canary without seeing the baseline.

**Assessed by:** Rina Okafor (DX Designer), 2025-07-25

---

## Entry 4: Round 4 Onboarding — Interactive Wizard and Compatibility Mode

**Date:** 2025-08-10
**Change:** Gridline acquisition — 200-line bash script deploys, docker-compose, no K8s. 90 days to onboard for SOC2. Product created [US-006](../product/user-stories.md#us-006-new-team-onboarding), [US-007](../product/user-stories.md#us-007-non-kubernetes-stack-onboarding), [E3](../product/epics.md#e3-onboarding-and-compatibility). Architecture introduced [Onboarding Service](../architecture/architecture.md#onboarding-service) with compatibility mode.

**Impact on DX:**
- CLI spec: `pave init` wizard created with stack detection, interactive prompts, compatibility warnings
- Dashboard spec: D8 (Onboarding Status) created — progress tracking for new teams
- Design decision DD-003 created: interactive wizard over docs-only onboarding
- Error catalog: PAVE-CFG-001, PAVE-CFG-002 added
- Onboarding flows: Flow 5 (new team onboarding) created

**Items reevaluated:**
- cli-spec.md: Section 4 (onboarding commands) created
- dashboard-specs.md: D8 created
- error-catalog.md: PAVE-CFG-* errors added
- design-decisions.md: DD-003 added
- onboarding-flows.md: Flow 5 created

**Result:** Gridline can go from zero to first staging deploy in under 30 minutes using the wizard. Compatibility limitations are communicated upfront — no surprises.

**Assessed by:** Rina Okafor (DX Designer), 2025-08-10

---

## Entry 5: Round 5 SOC2 — RBAC and Audit Trail UX

**Date:** 2025-08-25
**Change:** SOC2 audit found every engineer had prod deploy access. An intern had deployed twice by accident. Product created [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance). Architecture introduced [RBAC Service](../architecture/architecture.md#rbac-service) and [Audit Service](../architecture/architecture.md#audit-service).

**Impact on DX:**
- CLI spec: `pave access grant/revoke/list` and `pave audit` commands created
- Dashboard spec: D4 (Audit Log) created — searchable, filterable, exportable for auditors
- Error catalog: PAVE-AUTH-001 through PAVE-AUTH-004 added
- Design decision DD-002 reinforced: permission-denied messages include required role, current role, who can grant, and the command to request
- Onboarding flows: Flow 9 (permission denied — what to do) created

**Items reevaluated:**
- cli-spec.md: Section 5 (admin commands) created
- dashboard-specs.md: D4 created
- error-catalog.md: PAVE-AUTH-* errors added
- onboarding-flows.md: Flow 9 created

**Result:** Every permission-denied error is self-documenting. Engineers never need to ask on Slack "who do I talk to about access" — the error message tells them. Audit log is immutable and export-ready for SOC2 auditors.

**Assessed by:** Rina Okafor (DX Designer), 2025-08-25

---

## Entry 6: Round 6 Pave Self-Outage — Manual Procedure and Queue Pause UX

**Date:** 2025-09-01
**Change:** Pave's own database migration locked the deploy_queue table for 4 hours. Nobody could deploy. Product created [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass) (revised). Architecture revised emergency deploy path and added queue pause/resume capability.

**Impact on DX:**
- CLI spec: `pave emergency deploy` redesigned (was `--force`, now requires `--acknowledge-audit`)
- Error catalog: PAVE-DEP-006 (queue paused) and PAVE-SYS-001 (service unreachable) updated with manual procedure inline
- Onboarding flows: Flow 10 (Pave is down — manual procedure) created
- Dashboard spec: D1 (Deploy Queue) updated with "queue paused" state

**Items reevaluated:**
- cli-spec.md: Section 8 (emergency commands) rewritten
- error-catalog.md: PAVE-DEP-006, PAVE-SYS-001 updated
- onboarding-flows.md: Flow 10 created
- dashboard-specs.md: D1 updated with queue paused state

**Result:** Manual deploy procedure documented inline in the PAVE-SYS-001 error message — when Pave is down, the error itself tells you the kubectl commands to deploy manually. **Status of Flow 10: suspect** — only validated in dry-run exercises, not a real outage.

**Assessed by:** Rina Okafor (DX Designer), 2025-09-01

---

## Entry 7: Round 7 KPI Gaming — Deploy Health Dashboard

**Date:** 2025-09-20
**Change:** VP mandated 10 deploys/week per team. Teams split PRs to game the number. Deploy frequency tripled, failure rate tripled. Product created [US-011](../product/user-stories.md#us-011-deploy-health-metrics), [E7](../product/epics.md#e7-platform-metrics-and-reporting). Architecture introduced [Metrics Service](../architecture/architecture.md#metrics-service).

**Impact on DX:**
- Dashboard spec: D5 (Deploy Health Dashboard) created — DORA-like metrics with team-relative baselines
- Design decision DD-007 created: metrics use team-relative baselines, not absolute numbers
- Deploy classification added to dashboard: feature, bugfix, config, dependency, README-only

**Items reevaluated:**
- dashboard-specs.md: D5 created
- design-decisions.md: DD-007 added

**Result:** Dashboard shows quality alongside quantity. A team deploying 3x/week with 0% failure rate is visibly healthier than a team deploying 20x/week with 30% failure. **Status of gaming detection threshold: suspect** — set from Round 7 data, needs recalibration after a full quarter.

**Assessed by:** Rina Okafor (DX Designer), 2025-09-20

---

## Entry 8: Round 8 Secrets — CLI and Dashboard for Rotation

**Date:** 2025-09-15
**Change:** Team Sentry's Redis credential expiration caused a 2 AM outage — one service missed the rotation window. Product created [US-008](../product/user-stories.md#us-008-secrets-rotation-without-redeploy), [E4](../product/epics.md#e4-secrets-management). Architecture introduced [Secrets Manager](../architecture/architecture.md#secrets-manager) with sidecar injection ([ADR-005](../architecture/adrs.md#adr-005-secrets-rotation-via-sidecar-injection)).

**Impact on DX:**
- CLI spec: Full secrets command suite — `pave secrets list`, `rotate`, `set`
- Dashboard spec: D6 (Secrets Dashboard) created — rotation status, upcoming expirations, bulk rotation
- Error catalog: PAVE-SEC-001 through PAVE-SEC-003 added
- Onboarding flows: Flow 6 (secret rotation) created

**Items reevaluated:**
- cli-spec.md: Section 3 (secrets commands) created
- dashboard-specs.md: D6 created
- error-catalog.md: PAVE-SEC-* errors added
- onboarding-flows.md: Flow 6 created

**Result:** Secret rotation is a single command with immediate propagation. No redeploy needed. The secrets dashboard shows "expiring soon" and "overdue" prominently — no more missed rotation windows.

**Assessed by:** Rina Okafor (DX Designer), 2025-09-15

---

## Entry 9: Round 9 PCI Approval — Slack Bot and Approval Queue

**Date:** 2025-10-20
**Change:** PCI DSS v4.0 requires security sign-off on all changes to payment-processing systems. Product created [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance). Architecture introduced [Approval Service](../architecture/architecture.md#approval-service).

**Impact on DX:**
- CLI spec: `pave approve request`, `pave approve`, `pave approve reject`, `pave approve status` created
- Dashboard spec: D7 (Approval Queue) created — pending approvals, history, self-approval guard
- Design decision DD-005 created: Slack bot as primary approval channel, dashboard as fallback
- Error catalog: PAVE-APR-001, PAVE-APR-002, PAVE-AUTH-003 added
- Onboarding flows: Flow 7 (PCI deploy with approval) created

**Items reevaluated:**
- cli-spec.md: Section 6 (approval commands) created
- dashboard-specs.md: D7 created
- error-catalog.md: PAVE-APR-* and PAVE-AUTH-003 added
- design-decisions.md: DD-005 added
- onboarding-flows.md: Flow 7 created

**Result:** Approval flow primarily in Slack where approvers already work. CLI and dashboard as secondary channels. Self-approval blocked at all levels (CLI, Slack bot, dashboard).

**Assessed by:** Rina Okafor (DX Designer), 2025-10-20

---

## Entry 10: Round 10 Existential — NPS and Time-Savings Evidence

**Date:** 2025-11-01
**Change:** CTO asked "why not buy Humanitec/Backstage?" Product needs evidence that Pave justifies its existence. No architecture change — DX needs to surface the data.

**Impact on DX:**
- Dashboard spec: D5 (Deploy Health Dashboard) evaluated for evidence extraction — existing metrics provide: time saved per deploy, reduction in failed deploys, onboarding time for new teams
- No new DX surfaces needed — the metrics already exist. The work is in presenting them persuasively to leadership.
- Marcus (PM) can export D5 data + D4 audit data + D8 onboarding completion rates to build the business case.

**Items reevaluated:**
- dashboard-specs.md: D5 — confirmed existing metrics cover what the CTO needs. No changes required.
- No DX artifacts changed — the evidence was already being captured.

**Result:** DX had been building the evidence all along. Deploy health metrics, audit trails, onboarding completion data, and NPS surveys provide the data the CTO requested. The work is PM's (presentation), not DX's (tooling).

**Assessed by:** Rina Okafor (DX Designer), 2025-11-01

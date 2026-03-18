# PRD: Canary Deploys

## Problem
Teams deploying to production today have two options: full rollout or don't deploy. There's no middle ground. When a deploy goes bad, 100% of traffic is affected from the moment the deploy completes. Rollback is the safety net, but it's reactive — the damage is already done.

Team Atlas (payments) processes $2M+ daily. They can't afford to route 100% of payment traffic to untested code. But they also can't stop deploying. They need a way to validate changes against real traffic with a limited blast radius before committing to a full rollout.

This isn't a payments-only problem. Every team deploying to production faces the same risk at different scales.

## Users
- **Developers** deploying changes to production who want to limit blast radius
- **Team leads** who need visibility into canary status across their services
- **Platform engineers** who need to configure and monitor canary infrastructure

## Solution
Canary deploys with configurable traffic splitting. A developer deploys a new version to a small percentage of traffic (e.g., 5%), monitors health metrics in real time, and either promotes to full rollout or cancels. If the error rate or latency exceeds a configurable threshold, Pave automatically rolls back the canary.

## Flow

1. **Deploy:** `pave deploy --canary 5` — routes 5% of traffic to new version
2. **Monitor:** Canary metrics visible in dashboard and CLI — error rate, latency, status codes
3. **Decision point:** Developer watches metrics during configurable canary window (default: 15 min)
4. **Promote:** `pave deploy --promote` — shifts 100% of traffic to new version
5. **Or cancel:** `pave deploy --cancel` — shifts all traffic back to stable version
6. **Or auto-rollback:** If error threshold breached for 60 consecutive seconds, Pave cancels automatically

## Requirements

**Must have:**
- Traffic splitting at 1%–50% granularity
- Real-time canary metrics: error rate, latency (p50, p95, p99), status code distribution
- Manual promote and cancel commands
- Auto-rollback on error rate threshold (default: 5%, configurable per service in `pave.yaml`)
- Canary deploy recorded in audit trail with outcome (promoted / cancelled / auto-rolled-back)
- Works with existing health check infrastructure
- Available to all teams, not gated by team or service type

**Should have:**
- Auto-rollback on latency threshold (e.g., p99 > 2s)
- Canary window timer with auto-promote if healthy for N minutes
- Canary comparison dashboard (canary vs. stable side-by-side)
- Slack/webhook notification on auto-rollback

**Won't have (for now):**
- Multi-stage canary (5% -> 25% -> 50% -> 100%) — teams can do this manually by running successive canary deploys
- A/B testing framework (canary is for safety, not experimentation)
- Canary for database migrations (deploy-time concern, not traffic concern)

## Dependencies
- E1 must be stable — atomic deploys and rollback are prerequisites
- Service must have a health check endpoint defined in `pave.yaml`
- Traffic splitting requires load balancer support (Istio for K8s, ALB for ECS)

## Risks
- **Traffic splitting accuracy:** Load balancer weighted routing may not be perfectly precise at low percentages. Mitigation: accept 5% tolerance, validate with traffic metrics.
- **Stateful services:** Canary doesn't work well for services with sticky sessions or local state. Mitigation: document limitation, recommend stateless design.
- **Metric noise:** Low traffic percentage means small sample size — error rate spikes may be noise, not signal. Mitigation: require 60 seconds of sustained threshold breach before auto-rollback.

## Success metrics
- 50% of production deploys use canary within 6 months of launch
- At least 3 auto-rollbacks prevent outages in the first quarter
- Mean time to detect bad deploys decreases (measured via MTTR in deploy health dashboard)

---

## Traceability

| Link type | References |
|-----------|------------|
| Epic | [E2: Progressive Rollout](epics.md#e2-progressive-rollout) |
| User Stories | [US-004: Canary deploy with traffic splitting](user-stories.md#us-004-canary-deploy-with-traffic-splitting), [US-005: Auto-rollback on error threshold](user-stories.md#us-005-auto-rollback-on-error-threshold) |
| Decisions | [DEC-003: Canary available to all teams](decision-log.md#dec-003-canary-available-to-all-teams-not-just-payments) |
| Architecture | [ADR-003: Canary via Weighted Traffic Splitting](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) |
| Experience | [CLI: `pave deploy --canary`](../experience/cli-spec.md#pave-deploy---canary), [CLI: `pave deploy --promote`](../experience/cli-spec.md#pave-deploy---promote), [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status) |
| Tests | [TC-201](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split) through [TC-205](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach) |
| Operations | [Alert: Canary Auto-Rollback](../operations/monitoring-alerting.md#alert-canary-auto-rollback) |
| Confirmed by | Marcus Chen (Platform Engineering Lead), 2025-07-10 |

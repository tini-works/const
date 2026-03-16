# DevOps — The Gap That Let It Die Silently

## What we discovered

FLW-99 (PDF export) had zero production signals. No success rate. No failure rate. No latency tracking. No alert. Nothing.

The PDF library died 8 months ago. The endpoint started returning 200 with empty bodies. Nobody noticed because there was nothing watching.

This is the gap. Every other flow in the system (FLW-12 dashboard aggregation, FLW-15 email digest) has production signals — latency, error rates, delivery confirmation. FLW-99 had none. It was unobservable.

**Verify:** Check the monitoring configuration (Datadog, Grafana, or equivalent). Search for any dashboard, alert, or metric referencing the export endpoint, PDF generation, or FLW-99. Zero results. The flow existed in Engineer's inventory and QA's proofs but not in production observability.

## Why it matters

An unobservable flow can break and stay broken indefinitely. The only thing that caught FLW-99 was a human doing manual reconciliation 8 months after the break. If the engineer hadn't walked their inventory that day, the ghost would still be there — broken, unused, but "proven" by a mock.

Production signals are the last line of defense. Tests can be mocked. Inventory can go stale. But a production signal on a dead endpoint fires immediately.

## What was removed

Nothing. That's the point. There was no infrastructure to remove because none was ever built for this flow. No dashboard panel to delete. No alert to silence. No metric to deprecate. The absence of infrastructure is the root cause.

**Verify:** Deployment of the export endpoint removal requires no monitoring changes. No alerts fire when the endpoint goes away, because no alerts existed.

## Current signal coverage (after cleanup)

| Flow | Production signal | Alert | Status |
|------|-------------------|-------|--------|
| FLW-12 Dashboard aggregation | Datadog latency + error rate | PagerDuty on P99 > 2s | Active, verified |
| FLW-15 Email digest | Delivery webhook + bounce rate | Slack on bounce > 5% | Active, verified |

Two flows, two with signals. 100% coverage. Before cleanup it was 2 of 3 (67%) — but the missing one was hidden because nobody checked.

**Verify:** For each active flow, confirm the production signal fires when the flow degrades. In staging: (a) slow down the dashboard data source — P99 alert fires. (b) Reject email deliveries — bounce rate alert fires. Both signals are proven, not assumed.

## New rule: every flow needs at least one production signal

| Rule | Detail |
|------|--------|
| Coverage requirement | Every flow in Engineer's inventory maps to at least one production signal |
| Audit cadence | Checked during sanity reconciliation — same cycle that checks staleness |
| Violation response | Flow is flagged as "unobservable" and escalated to Engineer + QA |
| Rationale | FLW-99 proved it: an unobservable flow is a ghost waiting to happen |

This isn't optional monitoring. It's a structural requirement. If a flow exists in the system, it must be observable in production. If it can't be observed, either add a signal or question whether the flow should exist.

**Verify:** Run the coverage audit now. List every flow in Engineer's inventory. For each, find its production signal in the monitoring configuration. The result should be 100% coverage. Any gap is a repeat of the FLW-99 failure mode.

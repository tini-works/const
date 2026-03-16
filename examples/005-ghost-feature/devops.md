# DevOps — Operations Registry

## Production Signals

| Flow | Signal | Alert | Status |
|------|--------|-------|--------|
| FLW-12 Dashboard aggregation | Datadog latency + error rate | PagerDuty on p99 > 2s | Active |
| FLW-15 Email digest | Delivery webhook + bounce rate | Slack on bounce > 5% | Active |
| ~~FLW-99 PDF export~~ | ~~None~~ | ~~None~~ | **Gap discovered** |

## FLW-99: Nothing to Remove

No infrastructure to remove. PDF export had no dedicated infra.

That's the problem. No observability signal. No degradation alert. No way to detect it silently broke. This is why it was dead for 8 months with nobody noticing.

## New Rule

**Every flow in the system registry must map to at least one production signal.**

| Rule | Detail |
|------|--------|
| Coverage | Every flow gets ≥1 production signal |
| Audit | Part of sanity reconciliation |
| Violation | Flag as unobservable, escalate to Engineer + QA |

An unobservable flow is a ghost waiting to happen. FLW-99 proved it.

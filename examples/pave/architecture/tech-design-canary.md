# Tech Design: Canary Deploys

**ADR:** [ADR-003](adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting)
**Epic:** [E2: Progressive Rollout](../product/epics.md#e2-progressive-rollout)
**Stories:** [US-004](../product/user-stories.md#us-004-canary-deploy-with-traffic-splitting), [US-005](../product/user-stories.md#us-005-auto-rollback-on-error-threshold)
**Verified by:** [TC-201](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split) through [TC-205](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-01

---

## Overview

Canary deploys allow teams to route a configurable percentage of traffic to a new version, compare metrics against the baseline, and automatically promote or rollback based on health thresholds. Implementation uses Istio VirtualService for traffic splitting and Prometheus for metric comparison.

**Prerequisite:** Istio service mesh must be installed in the target cluster. Canary is only available for `runtime: kubernetes` services.

---

## Canary Lifecycle

```
1. pave deploy checkout-api --canary --traffic 5
       │
       ▼
2. Deploy Engine builds canary image (same as normal deploy)
       │
       ▼
3. Deploy Engine creates canary Deployment:
   - Name: {service}-canary
   - Image: same commit SHA as the deploy
   - Labels: pave.io/canary=true, pave.io/deploy-id={uuid}
   - Same resource limits, env vars, secrets mounts as baseline
       │
       ▼
4. Canary Controller creates/updates Istio VirtualService:
   - Route[0]: destination={service}, weight=95
   - Route[1]: destination={service}-canary, weight=5
       │
       ▼
5. Canary Controller starts metric comparison loop (every 60s)
       │
       ├── Healthy for observation window → Auto-promote (or wait for manual)
       │
       └── Threshold breached for 3 consecutive checks → Auto-rollback
```

---

## Istio VirtualService Configuration

When a canary session starts, the Canary Controller creates or patches the VirtualService for the target service:

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: checkout-api
  namespace: production
  labels:
    pave.io/managed: "true"
    pave.io/canary-session: "uuid"
spec:
  hosts:
    - checkout-api
  http:
    - route:
        - destination:
            host: checkout-api
            subset: baseline
          weight: 95
        - destination:
            host: checkout-api
            subset: canary
          weight: 5
---
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: checkout-api
  namespace: production
spec:
  host: checkout-api
  subsets:
    - name: baseline
      labels:
        pave.io/canary: "false"
    - name: canary
      labels:
        pave.io/canary: "true"
```

**On promote:** The canary deployment replaces the baseline. The VirtualService is updated to 100% to the new deployment, and the old baseline deployment is scaled to 0 and then deleted.

**On abort/rollback:** The canary deployment is deleted. The VirtualService is updated to 100% to the baseline. Traffic instantly reverts.

---

## Metric Comparison Algorithm

The Canary Controller queries Prometheus every 60 seconds for both canary and baseline:

```promql
# Error rate for canary pods
sum(rate(http_requests_total{service="checkout-api", pave_canary="true", code=~"5.."}[1m]))
/
sum(rate(http_requests_total{service="checkout-api", pave_canary="true"}[1m]))

# Error rate for baseline pods
sum(rate(http_requests_total{service="checkout-api", pave_canary="false", code=~"5.."}[1m]))
/
sum(rate(http_requests_total{service="checkout-api", pave_canary="false"}[1m]))
```

**Comparison logic:**

```
for each metric_check (every 60s):
    canary_error_rate = query_prometheus(canary_error_query)
    baseline_error_rate = query_prometheus(baseline_error_query)

    if canary_error_rate == 0 and baseline_error_rate == 0:
        verdict = "healthy" (no errors anywhere)
    elif baseline_error_rate == 0:
        if canary_error_rate > 0.001:
            verdict = "unhealthy" (canary has errors, baseline doesn't)
        else:
            verdict = "healthy" (negligible canary error rate)
    else:
        ratio = canary_error_rate / baseline_error_rate
        if ratio > threshold.error_rate_multiplier:
            verdict = "unhealthy"
        else:
            verdict = "healthy"

    if verdict == "unhealthy":
        consecutive_failures += 1
    else:
        consecutive_failures = 0

    if consecutive_failures >= 3:
        trigger_auto_rollback()
```

**Minimum traffic threshold:** If the canary has received fewer than 100 requests during a check window, the check is skipped (marked as "insufficient traffic"). This prevents false signals from low-traffic services. After 5 consecutive "insufficient traffic" checks, an alert fires — the canary window may need to be extended or traffic percentage increased.

---

## Thresholds

Configurable per service in `pave.yaml`:

```yaml
canary:
  enabled: true
  default_traffic: 5
  thresholds:
    error_rate_multiplier: 2.0    # rollback if canary error rate > 2x baseline
    latency_multiplier: 3.0       # SUSPECT — not yet implemented
    observation_window: 15m       # auto-promote after 15 min of healthy checks
    min_request_count: 100        # skip check if < 100 requests in window
```

| Metric | Default | Configurable | Implemented |
|--------|---------|:---:|:---:|
| Error rate (ratio to baseline) | 2.0× | Yes | Yes |
| p99 latency (ratio to baseline) | 3.0× | Yes | **No — suspect** |
| Health check failures | > 0 | No | Yes |
| Observation window | 15 min | Yes | Yes |
| Consecutive failures for rollback | 3 | No | Yes |
| Minimum request count | 100 | Yes | Yes |

**Latency-based rollback is suspect.** TC-202 verifies error-rate comparison. Latency comparison query is written but the rollback trigger path is untested. Flagged in the [reconciliation log](reconciliation-log.md#entry-2-canary-deploy-round-3).

---

## Auto-Rollback Flow

```
Canary Controller detects 3 consecutive unhealthy checks
    │
    ▼
1. Set canary_session.status = 'auto_rollback'
2. Delete canary Deployment
3. Update VirtualService: 100% to baseline
4. Create rollback deploy record (is_rollback=true)
5. Write audit_log: canary.auto_rollback
6. Notify deployer via Slack:
   "🚨 Canary auto-rollback: checkout-api/production
    Error rate 3.2x baseline (threshold: 2.0x)
    Rolled back to commit def456a"
7. Update deploy status: rolled_back
```

**Manual abort** follows the same flow but is triggered by `POST /deploys/{id}/canary/abort` or `pave canary abort`.

---

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Canary pod crashes during rollout | Health check failure → immediate auto-rollback (no 3-check wait) |
| Prometheus is unreachable | Checks return "unknown" — after 5 consecutive unknowns, canary is aborted with reason "metrics unavailable" |
| Deployer triggers another deploy during canary | Rejected — 409 "deploy in progress" |
| Canary traffic is 0 requests (service has no traffic) | After 10 min of "insufficient traffic," alert fires and canary auto-aborts |
| VirtualService already exists (non-Pave managed) | Pre-flight check fails — canary aborted with error "existing VirtualService not managed by Pave" |

---

## Known Gaps

1. **Latency-based thresholds:** Query is written, rollback trigger is not. Need TC for this path.
2. **Docker Compose services:** No canary support. Compose adapter doesn't support traffic splitting.
3. **Low-traffic services:** The 100-request minimum means canary may not be useful for services with < 1 req/sec.
4. **Multi-region:** Canary is per-cluster. If the service runs in multiple clusters, each needs its own canary session.

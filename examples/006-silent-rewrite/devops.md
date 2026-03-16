# DevOps — Order Processing

Auto-notified when Engineer's deployment inventory changed. Verified.

## Infrastructure diff

| | Before | After |
|---|--------|-------|
| Runtime | Python 3.11 | Go 1.22 |
| Container | python:3.11-slim (890MB) | scratch + static binary (12MB) |
| Resources | 4 CPU / 4GB RAM | 2 CPU / 512MB RAM |
| Replicas | 3 | 3 (unchanged) |

**Verify:** `kubectl describe deployment order-processing` — image tag is Go build, resource limits are 2CPU/512MB. `kubectl top pods -l app=order-processing` — RSS under 340MB per pod.

## Monitoring remapped

Same thresholds, new targets. No alert logic changed — only the service name in selectors.

| Signal | Threshold | Change | Verify |
|--------|-----------|--------|--------|
| Order processing latency | P95 < 500ms | Target: `order-processing-go` | Grafana dashboard `order-ops`. Current P95: 92ms. |
| Order processing error rate | < 0.1% over 5min | Target: `order-processing-go` | Alert rule `order-error-rate`. Fire test: kill one pod, confirm alert triggers on threshold breach. |
| Order processing uptime | 99.9% SLA | Healthcheck: `/healthz` on Go service | `curl https://order-processing.internal/healthz` returns 200. Uptime monitor confirms 99.97% during rollout window. |

## Canary metrics (5% traffic, 24h window)

| Metric | Go | Python | Verdict |
|--------|-----|--------|---------|
| Error rate | 0.02% | 0.03% | Go cleaner |
| P95 latency | 92ms | 375ms | Go 4x faster |
| SLA during rollout | 99.97% | — | Within B4 |

**Verify:** Grafana `canary-comparison` dashboard, time range: rollout window. Both series visible, Go outperforms on every metric.

## Post-rollout

- Python service decommissioned. Container image archived to cold registry.
- Python runtime dependencies removed from production cluster.
- Go service at 100% traffic. All operational boxes exceeded.

**Verify:** `kubectl get deployments -l stack=python` — empty. `helm list | grep order-processing` — single release, Go chart.

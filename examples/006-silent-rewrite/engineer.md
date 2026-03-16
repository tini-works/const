# Engineer — Order Processing Rewrite

No permission asked. Contracts held.

## What changed vs what didn't

| | Before | After |
|---|--------|-------|
| Language | Python 3.11 | Go 1.22 |
| Architecture | Monolith module | Microservice |
| P95 latency | 380ms | 92ms |
| Memory | 2.1GB | 340MB |
| Cold start | 12s | 0.8s |
| Container | python:3.11-slim | scratch (static binary) |

| Unchanged | |
|-----------|---|
| API contract | Same endpoints, same request/response shapes |
| Event payloads | Same topics, same schemas |
| B1-B5 | All contracts held. All exceeded. |

## Deployment sequence

### 1. Local verification

Ran all 47 QA verification paths against the Go service locally.

**Verify:** `make test-all` — 47/47 pass. Same test suite, new binary. Tests hit the API surface, not the implementation.

### 2. Staging load test

Deployed to staging. Load tested at 2000 concurrent orders (4x the B2 contract of 500).

**Verify:** `hey -n 10000 -c 2000 https://staging.internal/api/orders` — P95 92ms, zero failures. DevOps confirmed resource usage: 340MB RSS, 2 CPU cores idle.

### 3. Canary (5% traffic, 24 hours)

Go service took 5% of production traffic alongside the Python service.

**Verify:** Side-by-side comparison over 24h window:

| Metric | Go (5%) | Python (95%) |
|--------|---------|-------------|
| Error rate | 0.02% | 0.03% |
| P95 latency | 92ms | 375ms |
| Order completion rate | identical | identical |

No anomalies. Go was cleaner on every metric.

### 4. Full rollout

Promoted Go to 100%. Python decommissioned.

**Verify:** `kubectl get pods -l app=order-processing` — all pods running Go image. `kubectl get pods -l app=order-processing-python` — no pods. DevOps confirmed all dashboards green, all alerts quiet.

## Who was notified and why

| Role | Notified? | Why |
|------|-----------|-----|
| QA | Yes (auto) | Implementation changed. Proofs must be re-established. |
| DevOps | Yes (auto) | Infrastructure changed. Operational boxes must be re-verified. |
| PM | No | B1, B2 unaffected. No contract touched. |
| Design | No | B3 unaffected. API contract unchanged. |

The transition mechanic fired on Engineer's inventory change. It notified the right verticals and skipped the irrelevant ones.

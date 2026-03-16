# Engineer Inventory — Order Processing

## What changed

| | Before | After |
|---|--------|-------|
| Language | Python 3.11 | Go 1.22 |
| Architecture | Monolith module | Microservice |
| P95 latency | 380ms | 92ms |
| Memory | 2.1GB | 340MB |
| Cold start | 12s | 0.8s |

## What didn't change

API contract v1 — same endpoints, same request/response shapes, same event payloads. PM and Design contracts unaffected.

## Deployment sequence

1. Local: all 47 verification paths pass against Go service
2. Staging: load test at 2000 concurrent (4x contract), P95 92ms
3. Canary: 5% traffic, 24h — Go 0.02% error rate vs Python 0.03%
4. Full rollout. Python decommissioned.

No permission asked. Contracts held.

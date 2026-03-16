# DevOps Inventory — Order Processing

## Infrastructure changes

| | Before | After |
|---|--------|-------|
| Runtime | Python 3.11, 2.1GB RAM | Go 1.22, 340MB RAM |
| Container | python:3.11-slim | scratch (static binary) |
| Resources | 4 CPU / 4GB | 2 CPU / 512MB |

## Monitoring remapped

| Signal | Change |
|--------|--------|
| Order processing latency | Same thresholds, new service target |
| Order processing error rate | Same thresholds, new service target |
| Order processing uptime | Same SLA (99.9%), new healthcheck endpoint |

## Canary metrics (5% traffic, 24h)

- Error rate: Go 0.02% vs Python 0.03%
- P95 latency: Go 92ms vs Python 375ms
- SLA during rollout: 99.97%

## Post-rollout

Python service decommissioned, container image archived. Go service at 100% traffic. All operational thresholds exceeded.

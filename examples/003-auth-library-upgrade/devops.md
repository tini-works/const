# DevOps Inventory — 003 Auth Library Migration

**Engineer flows to cover:** FLW-30..32

## Deployment Strategy

| ID | Item | Detail |
|----|------|--------|
| DEP-30 | Canary | v2 token issuance at 5% traffic, monitor error rates |
| DEP-31 | Circuit breaker | v2 validation fails → automatic fallback to v1 |
| DEP-32 | Rollback | Per-service config flag revert, no redeployment |

## Observability

| ID | Signal | Monitor |
|----|--------|---------|
| OBS-30 | Token version ratio | Dashboard: v1 vs v2 across all services (live) |
| OBS-31 | v2 validation failure rate | Alert if >0.1% |
| OBS-32 | v1 token usage post-grace | Alert: should be zero after day 30 |

## Environment Parity

| Item | Detail |
|------|--------|
| Staging | Both v1 and v2 signing keys available |
| Load test | Mixed v1/v2 token traffic at production scale |

## Migration Timeline (DevOps View)

```
Day 0:  Canary begins (5% v2 issuance)
Day 1:  OBS-31 — zero failures at 5%
Day 3:  Canary → 25%
Day 7:  Canary → 100% for opted-in services
Day 20: OBS-30 — 62% v2 ratio
Day 30: Grace expires, OBS-32 activated, DEP-31 removed, v1 keys decommissioned
```

## Post-Migration Steady State

| Item | State |
|------|-------|
| OBS-30 | v2 ratio: 100% |
| OBS-32 | Active — should never fire |
| DEP-31 | Removed (circuit breaker no longer needed) |
| v1 signing keys | Decommissioned from all environments |

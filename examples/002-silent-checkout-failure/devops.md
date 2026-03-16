# DevOps Inventory — 002 Silent Checkout Failure

**Engineer flows to cover:** FLW-10..13

## Observability

| ID | Signal | Monitor |
|----|--------|---------|
| OBS-10 | Payment error rate by category | Dashboard: card/temp/unknown breakdown |
| OBS-11 | Unknown-category error rate | Alert if >5% of total failures |
| OBS-12 | Duplicate charge detection | Alert from payment reconciliation feed |
| OBS-13 | Correlation ID lookup | Dashboard for support team |

## Deployment

| Item | Detail |
|------|--------|
| Canary | Gateway client change requires canary deploy (payment = critical path) |
| Rollback | Feature flag on body-parsing logic, fallback to old behavior |

## Environment Parity

| Item | Detail |
|------|--------|
| Staging gateway simulator | Supports all 4 error categories |
| Load test | 1000 concurrent checkouts, mixed success/failure |

## Flow Coverage

| Engineer flow | Signal | Gap? |
|--------------|--------|------|
| FLW-10 (checkout → gateway → categorize) | OBS-10 | No |
| FLW-11 (error categorization) | OBS-11 | No |
| FLW-12 (correlation ID logging) | OBS-13 | No |
| FLW-13 (idempotency) | OBS-12 | No |

**Full observability coverage.**

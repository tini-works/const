# Operations Registry — Silent Checkout Failure

## Monitoring

| ID | Signal | Implementation | Alert threshold |
|----|--------|---------------|-----------------|
| OBS-10 | Payment error rate by category | Dashboard: card / temp / bank / unknown breakdown, 5-min windows | Error rate > 2x baseline for any category |
| OBS-11 | Unknown-category error rate | Percentage of failures that don't map to known taxonomy | > 5% of total failures (means gateway changed or new error code) |
| OBS-12 | Duplicate charge detection | Payment reconciliation feed, flag same-user same-amount within 60s | Any duplicate → immediate alert to payments team |
| OBS-13 | Correlation ID lookup | Support dashboard: search by customer email or correlation ID → full payment attempt history | N/A (query tool, not alerting) |

## Deployment

| Control | Detail |
|---------|--------|
| Canary deploy | Gateway client change goes through canary first — checkout is the critical revenue path. 5% traffic for 30 min, watch OBS-10 for error rate changes. |
| Feature flag | `checkout.parse_response_body` — toggles between old (HTTP-status-only) and new (body-parsing) behavior. Rollback = flip flag, no redeploy. |
| Rollback trigger | OBS-10 error rate > 3x baseline OR any OBS-12 duplicate charge alert during canary → automatic flag rollback. |

## Staging Environment

| Component | Detail |
|-----------|--------|
| Gateway simulator | Supports all 4 error categories + configurable latency + malformed responses. QA's VP-10..14 run against this. |
| Load test | 1,000 concurrent checkouts, mixed success/failure/timeout. Validates idempotency under load. Run before every production deploy. |
| Error injection | Simulate gateway returning new/unknown error codes to verify OBS-11 catches them and UI falls back to SCR-12. |

## Runbook: Payment Error Spike

1. Check OBS-10 — which category is spiking?
2. If `unknown` — gateway may have changed error codes. Check OBS-11, pull recent correlation IDs from OBS-13, compare gateway responses against taxonomy.
3. If `card` or `temp` spiking — likely upstream (bank/gateway issue). Verify with gateway status page.
4. If OBS-12 fires — duplicate charges. Kill switch: disable retry button via feature flag `checkout.allow_retry`. Investigate idempotency key generation.
5. Escalation: payments team for charge reversal, PM for customer communication.

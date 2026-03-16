# DevOps Inventory — Auth Library Migration (JWT v1 → v2)

## Deployment Strategy

| Mechanism | Detail |
|-----------|--------|
| Canary | v2 token issuance starts at 5% traffic, ramp on clean metrics |
| Circuit breaker | v2 validation failure → automatic fallback to v1 validation |
| Rollback | Per-service config flag revert (`auth.token_version = v1`), no redeploy needed |

## Observability

| Signal | Dashboard / Alert | Threshold |
|--------|-------------------|-----------|
| Token version ratio | Live dashboard: v1 vs v2 across all services | Track, no alert |
| v2 validation failure rate | Alert | > 0.1% |
| v1 token usage post-grace | Alert | > 0 after day 30 |

## Environment Parity

- **Staging:** Both v1 and v2 signing keys available, dual-mode enabled
- **Load test:** Mixed v1/v2 token traffic at production scale before rollout

## Migration Timeline (Ops View)

```
Day 0:   Canary begins — 5% of traffic gets v2 tokens
Day 1:   Zero v2 failures at 5%, proceed
Day 3:   Canary → 25% v2 issuance
Day 7:   100% v2 issuance for opted-in services
Day 20:  Token ratio: 62% v2 across all services
Day 30:  Grace expires:
           - v1 fallback path disabled
           - Circuit breaker removed
           - v1 signing keys decommissioned from all environments
           - Post-grace alert (v1 usage > 0) activated
```

## Steady State (Post Day 30)

| Item | State |
|------|-------|
| Token ratio | 100% v2 |
| v1 post-grace alert | Active — should never fire |
| Circuit breaker | Removed |
| v1 signing keys | Gone |

# DevOps Inventory — Faces Operational Reality

Proves that the system **runs** as designed, not just that it was **built** as designed.

**Contains:** Infrastructure state. Deployment pipelines. Environment parity. Observability coverage.

**Proven means:** Every deployment path is reproducible. Environments match what QA needs. Observability covers every flow in Engineer's inventory. Incidents trace back to a broken match.

---

## Entry 001 — Patient Check-In

**Engineer flows to cover operationally:** FLW-01..04 (check-in scan, two-source fetch, diff/populate, staleness check)

### Infrastructure

| Item | Detail |
|------|--------|
| HIS API integration | Demographics endpoint (Module A) + Allergies endpoint (Module B) |
| SLA | HIS API response time < 2s at check-in |

### Environment parity

| Item | Detail |
|------|--------|
| Test patient data | Seeded with realistic records, varying staleness dates |
| Staleness coverage | Fresh, 3mo, 6mo, 12mo, 24mo records available in test env |

### Observability

| ID | Signal | Monitors |
|----|--------|----------|
| OBS-01 | Allergy-fetch failure rate | Alert if >1% over 5min window |
| OBS-02 | Check-in flow latency | Dashboard: P50, P95, P99 |
| OBS-03 | Staff review queue depth | Alert if >50 (anomaly detection) |

### Coverage mapping

| Engineer flow | Observability signal | Gap? |
|--------------|---------------------|------|
| FLW-01 (check-in scan) | OBS-02 (latency) | No |
| FLW-02 (two-source fetch) | OBS-01 (failure rate), OBS-02 (latency) | No |
| FLW-03 (diff/populate) | OBS-02 (latency) | No |
| FLW-04 (staleness check) | OBS-01 (allergy fetch), OBS-03 (queue depth) | No |

**Full observability coverage across all Engineer flows.**

---

## Entry 002 — Silent Checkout Failure

**Engineer flows to cover:** FLW-10..13 (checkout→gateway, error categorization, correlation logging, idempotency)

### Observability

| ID | Signal | Monitors |
|----|--------|----------|
| OBS-10 | Payment error rate by category | Dashboard: card/temp/unknown breakdown |
| OBS-11 | Unknown-category error rate | Alert if >5% of total failures |
| OBS-12 | Duplicate charge detection | Alert from payment reconciliation feed |
| OBS-13 | Correlation ID lookup | Dashboard for support team |

### Deployment

| Item | Detail |
|------|--------|
| Canary | Gateway client change requires canary deploy (payment = critical path) |
| Rollback | Feature flag on body-parsing logic, fallback to old behavior |

### Environment parity

| Item | Detail |
|------|--------|
| Staging gateway simulator | Supports all 4 error categories (card_expired, insufficient_funds, temp_decline, unknown) |
| Load test | 1000 concurrent checkouts, mixed success/failure |

### Coverage mapping

| Engineer flow | Observability signal | Gap? |
|--------------|---------------------|------|
| FLW-10 (checkout → gateway → categorize) | OBS-10 (error rate by category) | No |
| FLW-11 (error categorization) | OBS-11 (unknown rate alert) | No |
| FLW-12 (correlation ID logging) | OBS-13 (lookup dashboard) | No |
| FLW-13 (idempotency) | OBS-12 (duplicate charge alert) | No |

**Full coverage. Every flow has a production signal.**

---

## Entry 003 — Auth Library Migration

**Engineer flows to cover:** FLW-30..32 (dual-mode validation, opt-in issuance, grace period)

### Deployment strategy

| ID | Item | Detail |
|----|------|--------|
| DEP-30 | Canary | v2 token issuance at 5% traffic, monitor error rates |
| DEP-31 | Circuit breaker | v2 validation fails → automatic fallback to v1 |
| DEP-32 | Rollback | Per-service config flag revert, no redeployment needed |

### Observability

| ID | Signal | Monitors |
|----|--------|----------|
| OBS-30 | Token version ratio | Dashboard: v1 vs v2 across all services (live) |
| OBS-31 | v2 validation failure rate | Alert if >0.1% |
| OBS-32 | v1 token usage post-grace | Alert: should be zero after day 30 |

### Environment parity

| Item | Detail |
|------|--------|
| Staging | Both v1 and v2 signing keys available |
| Load test | Mixed v1/v2 token traffic at production scale |

### Migration timeline (DevOps view)

```
Day 0:  Library published, canary begins (DEP-30)
Day 1:  OBS-31 — zero v2 validation failures at 5% traffic
Day 3:  Canary expanded to 25%
Day 7:  Canary at 100% — all issuance through v2 for opted-in services
Day 20: OBS-30 — 62% v2 (Services A, C), 38% v1 (Services B, D)
Day 30: Grace period expired
        OBS-32 activated — no v1 tokens should appear
        DEP-31 circuit breaker removed
        v1 signing keys decommissioned from all environments
```

### Post-migration steady state

| Item | State |
|------|-------|
| OBS-30 | v2 ratio: 100% |
| OBS-32 | Active — should never fire |
| DEP-31 | Removed (circuit breaker no longer needed) |
| v1 keys | Decommissioned |

---

## Entry 004 — Dark Mode

**No DevOps inventory changes.**

This is a frontend-only change: CSS custom properties + localStorage + existing profile API endpoint. No new infrastructure. No deployment strategy beyond normal CI/CD. No observability gaps — the existing frontend error monitoring covers it.

**Correct behavior.** Not every feature needs DevOps inventory changes. If no operational boxes are affected, DevOps stays out.

---

## Entry 005 — Ghost Feature Removal

**No infrastructure to remove.** The PDF export feature had no dedicated infrastructure.

But that's the problem.

### Gap discovered

The PDF export feature had:
- No observability signal in production
- No degradation alert
- No way to detect that it was silently broken

**This is why it died without anyone noticing.** If DevOps had required observability coverage for FLW-99, the deprecation of the PDF library would have triggered an alert 8 months ago.

### Systemic rule added

**Observability audit:** Every flow in Engineer's inventory must map to at least one production signal. Flows with zero signals are flagged as **unobservable**.

| Rule | Detail |
|------|--------|
| Coverage requirement | Every Engineer flow → ≥1 DevOps observability signal |
| Audit frequency | Part of daily sanity reconciliation |
| Violation response | Flag flow as unobservable, escalate to Engineer + QA |

An unobservable flow is a ghost waiting to happen.

---

## Entry 006 — Order Service Rewrite

**Engineer's implementation changed.** DevOps auto-notified by transition mechanic.

### Infrastructure changes

| Item | Before | After |
|------|--------|-------|
| Runtime | Python 3.11, 2.1GB RAM | Go 1.22, 340MB RAM |
| Container | python:3.11-slim | golang:1.22-alpine (then scratch) |
| Cold start | 12s | 0.8s |
| Resource profile | 4 CPU, 4GB mem | 2 CPU, 512MB mem |

### Observability remapped

| ID | Signal | Change |
|----|--------|--------|
| OBS-60 | Order processing latency | Same thresholds, new service target |
| OBS-61 | Order processing error rate | Same thresholds, new service target |
| OBS-62 | Order processing uptime | Same SLA (99.9%), new healthcheck endpoint |

Dashboards updated. Alert targets remapped. Same boxes, new plumbing.

### Deployment verification

| Check | Result |
|-------|--------|
| Canary (5%, 24h) | Error rate: Go 0.02% vs Python 0.03% |
| Latency | Go P95 92ms vs Python P95 375ms |
| Resource usage | 6x memory reduction |
| SLA | 99.9% maintained during rollout |

### Post-rollout

| Item | State |
|------|-------|
| Python service | Decommissioned, container image archived |
| Go service | Production, 100% traffic |
| Operational boxes | All exceeded (not just matched) |

**DevOps verified operational boxes without being told what to check.** The transition mechanic notified them. Their inventory told them which boxes apply. They re-verified. Done.

---

## Sanity checklist (daily reconciliation)

| Dimension | Question | Action if yes |
|-----------|----------|---------------|
| Staleness | Is this infrastructure serving a live Engineer flow? | Decommission if orphaned |
| Correctness | Do environments match production? Do alerts fire when they should? | Fix parity gaps, test alert paths |
| Coverage | Does every Engineer flow have ≥1 production observability signal? | Flag unobservable flows (see Entry 005 rule) |

### Integrity rules

| Rule | Rationale | Source |
|------|-----------|--------|
| Every Engineer flow → ≥1 observability signal | Unobservable flows die silently | Entry 005 |
| Environment parity is proven, not assumed | "Works in staging" means nothing if staging doesn't match prod | Constitution |
| Deployment paths are reproducible | If you can't redeploy from scratch, you can't roll back | Constitution |
| Incidents trace to broken matches | Every outage should point to which box broke | Constitution |

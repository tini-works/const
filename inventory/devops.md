# Operations Registry

What's deployed, where, how we'd know if it broke, and how we'd roll it back. If a flow doesn't have a signal in production, it's invisible — and invisible things die silently.

**Flow coverage: 14/14 (100%)** | 0 unobservable flows | Active alerts: 9

---

## Infrastructure

| Service | Runtime | Resources | Deployment |
|---------|---------|-----------|------------|
| Order Processing | Go 1.22, scratch container | 2 CPU, 512MB | Canary → full rollout |
| Check-In Service | — | — | Standard CI/CD |
| Payment Gateway Client | — | — | Canary (payment = critical path), feature-flagged |
| Auth Library | v2.1 | Distributed (library, not service) | Per-service version bump |

| Decommissioned | When | Why |
|----------------|------|-----|
| Order Processing (Python) | Post-rewrite | Replaced by Go service, container archived |
| Auth v1 signing keys | Day 30 post-migration | Grace period expired |

## Monitoring & Alerts

### Check-In

| ID | What | Threshold | Why it matters |
|----|------|-----------|---------------|
| OBS-01 | Allergy-fetch failure rate | >1% over 5min | Patients can't check in if allergy data unavailable |
| OBS-02 | Check-in flow latency (P50/P95/P99) | Dashboard | SLA: <2s response |
| OBS-03 | Staff review queue depth | >50 (anomaly) | Could mean false positive flood |

### Payment

| ID | What | Threshold | Why it matters |
|----|------|-----------|---------------|
| OBS-10 | Payment error rate by category | Dashboard (card/temp/unknown) | Spot shifts in failure patterns |
| OBS-11 | Unknown-category error rate | >5% of total failures | Means gateway is returning codes we don't recognize |
| OBS-12 | Duplicate charge detection | Any occurrence | Reconciliation feed — customer-facing financial harm |
| OBS-13 | Correlation ID lookup | Dashboard for support | Support needs this to debug complaints |

### Auth

| ID | What | Threshold | Why it matters |
|----|------|-----------|---------------|
| OBS-30 | Token version ratio (v1 vs v2) | Dashboard | Steady state: 100% v2 |
| OBS-31 | v2 validation failure rate | >0.1% | Auth failures = users locked out |
| OBS-32 | v1 token usage post-grace | Any occurrence | Should never fire — means something is still issuing v1 |

### Order Processing

| ID | What | Threshold | Why it matters |
|----|------|-----------|---------------|
| OBS-60 | Order processing latency | P95 <500ms (SLA) | Currently 92ms — healthy margin |
| OBS-61 | Order processing error rate | Dashboard | Baseline: 0.02% |
| OBS-62 | Order processing uptime | 99.9% (SLA) | Currently 99.97% |

## Flow → Signal Coverage Map

Every flow in Engineering's registry must have at least one production signal here. No exceptions.

| Flow | Signal(s) | Gap? |
|------|-----------|------|
| FLW-01 Check-in scan | OBS-02 | No |
| FLW-02 Two-source fetch | OBS-01, OBS-02 | No |
| FLW-03 Diff/populate | OBS-02 | No |
| FLW-04 Staleness check | OBS-01, OBS-03 | No |
| FLW-10 Checkout → gateway | OBS-10 | No |
| FLW-11 Error categorization | OBS-11 | No |
| FLW-12 Correlation logging | OBS-13 | No |
| FLW-13 Idempotency | OBS-12 | No |
| FLW-30 Token validation | OBS-31 | No |
| FLW-31 Token issuance | OBS-30 | No |
| FLW-40 Color tokens | — (frontend CSS) | N/A |
| FLW-41 Theme toggle | — (frontend) | N/A |
| FLW-42 Opacity overlay | — (frontend CSS) | N/A |
| FLW-43 Preference sync | — (existing profile API) | N/A |

## Environments

| Environment | Purpose | Parity |
|-------------|---------|--------|
| Staging | Integration testing | HIS API simulator, payment gateway simulator, both auth signing keys |
| Load test | Capacity validation | Production-scale traffic, mixed success/failure scenarios |

| Test data | Detail |
|-----------|--------|
| Patient records | Varying staleness: fresh, 3mo, 6mo, 12mo, 24mo |
| Payment test cards | Trigger: success, expiry, decline, unknown error |
| Auth tokens | v2 (production), v1 (regression testing only) |

## Rollback Plans

| Service | How to roll back | Time to recover |
|---------|-----------------|----------------|
| Payment gateway client | Feature flag: disable body-parsing, revert to old behavior | Instant (flag toggle) |
| Order processing | Archived Python container still available | ~5min (redeploy) |
| Auth library | Per-service config flag revert, no redeployment | Instant (config change) |

## What happened when we didn't have coverage

PDF export (FLW-99) had zero production signals. The dependency died 8 months ago. Returns 200 + empty body. No alert. No dashboard. No one noticed. Three people tried to use it — got empty files — gave up silently.

An unobservable flow is a ghost waiting to happen.

## What Ops protects daily

1. **Every engineering flow → at least one production signal.** If we can't see it, we can't know when it dies. Run the coverage map. Flag gaps.
2. **Environments must match reality.** "Works in staging" is meaningless if staging doesn't have the same data shapes, failure modes, and scale as production.
3. **Rollback plans must exist before deploy, not after an incident.** Every critical-path deployment has a documented rollback. Untested rollback plans are fiction.

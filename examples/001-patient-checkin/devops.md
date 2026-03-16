# Operations Registry — Patient Check-In

**Flow coverage: 4/4 (100%)** | 0 unobservable flows | Active alerts: 2

---

## Infrastructure

| Service | Runtime | Deployment | SLA |
|---------|---------|------------|-----|
| Check-In Service | — | Standard CI/CD | HIS API response <2s |

| Integration | Detail |
|-------------|--------|
| HIS Module A | Demographics endpoint |
| HIS Module B | Allergies endpoint |

## Monitoring & Alerts

| ID | What | Threshold | Why it matters |
|----|------|-----------|---------------|
| OBS-01 | Allergy-fetch failure rate | >1% over 5min | Patients can't check in if allergy data unavailable |
| OBS-02 | Check-in flow latency (P50/P95/P99) | Dashboard, alert if P95 >2s | SLA breach = patient waiting at kiosk |
| OBS-03 | Staff review queue depth | >50 (anomaly) | Could mean false positive flood from bad diff logic |

## Flow → Signal Coverage

| Flow | Signal(s) | Gap? |
|------|-----------|------|
| FLW-01 Check-in scan | OBS-02 | No |
| FLW-02 Two-source fetch | OBS-01, OBS-02 | No |
| FLW-03 Diff/populate | OBS-02 | No |
| FLW-04 Staleness check | OBS-01, OBS-03 | No |

Every engineering flow has at least one production signal.

## Environments

| Environment | Purpose | Key detail |
|-------------|---------|------------|
| Staging | Integration testing | HIS API simulator for both modules |

| Test data | Detail |
|-----------|--------|
| Patient records | Varying staleness: fresh, 3mo, 6mo, 12mo, 24mo |

Staleness coverage is critical — without backdated records in the test environment, VP-03 can't run.

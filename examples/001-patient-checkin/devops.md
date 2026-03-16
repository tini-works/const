# DevOps Inventory — 001 Patient Check-In

**Engineer flows to cover:** FLW-01..04

## Infrastructure

| Item | Detail |
|------|--------|
| HIS API integration | Demographics endpoint (Module A) + Allergies endpoint (Module B) |
| SLA | HIS API response < 2s at check-in |

## Environment Parity

| Item | Detail |
|------|--------|
| Test patient data | Seeded with realistic records |
| Staleness coverage | Fresh, 3mo, 6mo, 12mo, 24mo records in test env |

## Observability

| ID | Signal | Monitor |
|----|--------|---------|
| OBS-01 | Allergy-fetch failure rate | Alert if >1% over 5min |
| OBS-02 | Check-in flow latency | Dashboard: P50, P95, P99 |
| OBS-03 | Staff review queue depth | Alert if >50 (anomaly) |

## Flow Coverage

| Engineer flow | Signal | Gap? |
|--------------|--------|------|
| FLW-01 (check-in scan) | OBS-02 | No |
| FLW-02 (two-source fetch) | OBS-01, OBS-02 | No |
| FLW-03 (diff/populate) | OBS-02 | No |
| FLW-04 (staleness check) | OBS-01, OBS-03 | No |

**Full observability coverage.**

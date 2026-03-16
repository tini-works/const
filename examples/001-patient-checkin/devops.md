# DevOps — Check-In Operations

## Infrastructure

| Dependency | Detail | SLA |
|------------|--------|-----|
| HIS Module A (demographics) | `GET /his/patients/{mrn}/demographics` | <1s response |
| HIS Module B (allergies) | `GET /his/patients/{mrn}/allergies` | <1s response |
| Check-in flow end-to-end | Scan → pre-filled form on kiosk | <2s total |

## Monitoring

### OBS-01: Allergy-fetch failure rate
**What it watches:** Failures when calling HIS Module B for allergy data.
**Threshold:** >1% of requests over a 5-minute window.
**Why it matters:** If allergies can't be fetched, the staleness check can't run, and patients might see an incomplete form or get stuck.
**Verify the signal works:** In staging, kill the HIS Module B simulator. Check in a patient. Alert should fire within 5 minutes.

### OBS-02: Check-in flow latency
**What it watches:** End-to-end time from card scan to form displayed. P50, P95, P99.
**Threshold:** Alert if P95 >2s (SLA breach — patient waiting at kiosk).
**Why it matters:** Both HIS calls happen in this window. If either module slows down, the patient stares at a loading screen.
**Verify the signal works:** In staging, add 1.5s delay to HIS Module A simulator. P95 should spike. Alert should fire.

### OBS-03: Staff review queue depth
**What it watches:** Number of unprocessed entries in the staff review queue.
**Threshold:** >50 entries (anomaly detection).
**Why it matters:** Could mean the diff logic (FLW-03) is producing false positives — flagging fields as changed when they haven't. Or it could mean the receptionist workflow is backed up.
**Verify the signal works:** In staging, trigger 60 check-ins with edits. Queue depth alert should fire.

## Test environment

| Data | What's seeded | Why |
|------|--------------|-----|
| TEST001 | Returning patient, all data fresh | VP-01, VP-02 baseline |
| TEST002 | Returning patient, address changed in HIS since last visit | VP-02 diff testing |
| TEST003 | Returning patient, allergy data last updated 8 months ago | VP-03 staleness testing |
| NEW001 | No prior visits | VP-04 regression |
| Staleness range | Patients with allergy data 3mo, 6mo, 12mo, 24mo old | Boundary testing for the 6-month threshold |

Without backdated allergy records in the test environment, VP-03 can't run and the staleness guard can't be proven.

## Flow → signal coverage

| Flow | Signal | Covers |
|------|--------|--------|
| FLW-01 Check-in scan + lookup | OBS-02 (latency) | Scan-to-response time |
| FLW-02 Two-source fetch | OBS-01 (failure rate) + OBS-02 (latency) | Module B health + total fetch time |
| FLW-03 Diff and populate | OBS-03 (queue depth) | False positive detection |
| FLW-04 Staleness check | OBS-01 (allergy fetch) | Module B must respond with timestamps |

Every engineering flow has a production signal. No unobservable flows.

# System Registry — Patient Check-In

**Proven: 4/4 flows (100%)** | 0 suspect

---

## Service

| Service | Status | SLA |
|---------|--------|-----|
| Check-In Service | Live | HIS API response <2s |

## API Contracts

| API | Contract | Consumers |
|-----|----------|-----------|
| Check-In API | Patient lookup by MRN, demographics + allergies fetch | Reception Kiosk, Staff Portal |

## Flows

| ID | Flow | What it proves |
|----|------|---------------|
| FLW-01 | Check-in scan → lookup patient by MRN → fetch last-visit snapshot | Returning patient detected, data retrieved |
| FLW-02 | Fetch demographics (HIS Module A) + allergies (HIS Module B) | Data persists across visits, two-source fetch works |
| FLW-03 | Diff current vs last-visit → populate form → flag changes | Pre-fill works, changes visible to staff |
| FLW-04 | Allergy staleness check (>6mo → force re-confirm) | Clinical safety — stale data caught before confirm |

## Decisions

| Decision | Why | Impact |
|----------|-----|--------|
| Two-source HIS fetch (demographics + allergies) | HIS stores them in separate modules — can't get both in one call | Added staleness risk that led to FLW-04 |
| 6-month staleness threshold | Clinical safety — allergy data can go stale without the patient knowing | Force re-confirmation, not silent accept |

## Upward discovery: allergy staleness

During implementation, Engineer found that HIS stores allergies separately from demographics. Allergy data can be arbitrarily stale. A "confirm" flow on stale allergy data is a clinical safety risk — the patient confirms data that may no longer be accurate.

Surfaced to PM and Design. PM accepted it as REQ-104 (patient safety is an external concern). Design added SCR-03 and a conditional branch. This is a case where the downstream vertical discovered something the upstream hadn't considered.

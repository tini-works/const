# Engineer Inventory — 001 Patient Check-In

**Boxes to match:** B1 (pre-filled + editable), B2 (persistence), B3 (confirm flow), B4 (confirm step), B5 (allergy staleness — originated here)

## Flows

| ID | Flow | Matches |
|----|------|---------|
| FLW-01 | Check-in scan → lookup patient by MRN → fetch last-visit snapshot | B1, B4 |
| FLW-02 | Fetch demographics (HIS Module A) + fetch allergies (HIS Module B) | B2 |
| FLW-03 | Diff current vs last-visit → populate form → flag changes | B1, B3 |
| FLW-04 | Allergy staleness check (>6mo → force re-confirm) | B5 |

## System Design

| Item | Detail |
|------|--------|
| Two-source data fetch | Demographics and allergies in separate HIS modules — two API calls required |
| Staleness threshold | 6-month cutoff on allergy records |

## Upward box: B5

Discovered during implementation: HIS stores allergies separately from demographics. Allergy data can be stale without the patient knowing. A "confirm" flow on stale allergy data is a clinical safety risk.

Surfaced B5 to PM and Design. Accepted — clinical safety.

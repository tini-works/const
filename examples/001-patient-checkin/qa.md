# QA Inventory — 001 Patient Check-In

**Boxes to cover:** B1-B5

## Verification Paths

| ID | Path | Mechanism | Degradation signal | Covers |
|----|------|-----------|-------------------|--------|
| VP-01 | Returning patient, no changes → confirm flow, no staff review | Integration test with test patient | Monitor review queue false positives | B1, B2, B3, B4 |
| VP-02 | Returning patient, insurance changed → staff review populated | Integration test, mutate insurance | Monitor queue miss rate | B1, B2 |
| VP-03 | Allergy data >6mo stale → forced re-confirmation screen | Integration test with backdated allergy record | Monitor allergy-fetch age headers | B2, B5 |
| VP-04 | New patient → full intake (regression) | Existing intake test suite | Existing monitors | B4 |

## Coverage Matrix

| Box | Verification paths | Degradation signal? |
|-----|-------------------|-------------------|
| B1 | VP-01, VP-02 | Yes |
| B2 | VP-01, VP-02, VP-03 | Yes |
| B3 | VP-01 | Yes |
| B4 | VP-01, VP-04 | Yes |
| B5 | VP-03 | Yes |

**Full coverage. Every box → path → mechanism → degradation signal.**

## ABRD991 — OPS codes from EBM Annex 2 must be mandatory when...

| Field | Value |
|-------|-------|
| **ID** | ABRD991 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1, KBV EBM |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD991](../../user-stories/US-ABRD991.md) |

### Requirement

OPS codes from EBM Annex 2 must be mandatory when applicable

### Acceptance Criteria

1. Given a Leistung requiring OPS per EBM Anhang 2, when no OPS code is documented, then validation reports a mandatory-field error

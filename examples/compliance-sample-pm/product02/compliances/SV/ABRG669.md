## ABRG669 — Chronic care flat-rate must require at least one confirmed permanent...

| Field | Value |
|-------|-------|
| **ID** | ABRG669 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a, BG-2 |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG669](../../user-stories/US-ABRG669.md) |

### Requirement

Chronic care flat-rate must require at least one confirmed permanent diagnosis — billing must be blocked if only acute diagnoses exist as permanent

### Acceptance Criteria

1. Given a Chronikerpauschale billed, when only akute Diagnosen exist as Dauerdiagnose, then billing is blocked with a diagnosis-type error

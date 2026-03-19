## VSST625 — The Vertragssoftware must ensure that Hilfsmittel prescriptions by product type...

| Field | Value |
|-------|-------|
| **ID** | VSST625 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST625](../../user-stories/US-VSST625.md) |

### Requirement

The Vertragssoftware must ensure that Hilfsmittel prescriptions by product type (7-digit Positionsnummer, standard case) are clearly prioritized over individual product prescriptions (exception case), separated by at least one workflow step

### Acceptance Criteria

1. Given a Hilfsmittel prescription, when the user selects a product type (7-digit), then it is presented as the standard case
2. Given individual product selection (10-digit), then it requires an additional workflow step confirming the exception

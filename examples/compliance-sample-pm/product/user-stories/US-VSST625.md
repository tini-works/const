## US-VSST625 — The Vertragssoftware must ensure that Hilfsmittel prescriptions by product type...

| Field | Value |
|-------|-------|
| **ID** | US-VSST625 |
| **Traced from** | [VSST625](../compliances/SV/VSST625.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware ensure that Hilfsmittel prescriptions by product type (7-digit Positionsnummer, standard case) are clearly prioritized over individual product prescriptions (exception case), separated by at least one workflow step, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Hilfsmittel prescription, when the user selects a product type (7-digit), then it is presented as the standard case
2. Given individual product selection (10-digit), then it requires an additional workflow step confirming the exception

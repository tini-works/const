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

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/himi`

1. **Product type search** -- The `SearchProductByBaseAndArt` method supports searching by base Hilfsmittel hierarchy (Gruppe, Ort, Unter) and Art type.
2. **7-digit vs 10-digit** -- The `BaseHimiSearch` struct uses Gruppe/Ort/Unter fields for hierarchical navigation.
3. **Gap: Workflow step separation** -- The specific UI enforcement of separating product type (7-digit) prescriptions from individual product (10-digit) prescriptions by at least one workflow step is a frontend concern not verified in the backend.

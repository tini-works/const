## US-ABRD994 — Material costs associated with services must be documentable with manufacturer/supplier...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD994 |
| **Traced from** | [ABRD994](../compliances/SV/ABRD994.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want material costs associated with services is documentable with manufacturer/supplier and article details, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Leistung with Sachkosten, when material details are entered, then manufacturer, supplier, and article fields are persisted

### Actual Acceptance Criteria

1. Partially implemented -- `MaterialCosts` exists with Amount/Description via `catalog_material_cost`.
2. `patient_encounter.GetMaterialCosts` retrieves entries but manufacturer/supplier/article fields not confirmed.

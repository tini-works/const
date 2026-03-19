## US-VERE792 — Module contract enrollment must be supported

| Field | Value |
|-------|-------|
| **ID** | US-VERE792 |
| **Traced from** | [VERE792](../compliances/SV/VERE792.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want module contract enrollment is supported, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a Modulvertrag, when enrollment is initiated, then a module-specific TE is created linked to the Hauptvertrag

### Actual Acceptance Criteria

1. Implemented -- `enrollment.CreatePatientEnrollment` creates enrollment per contract.
2. `contract.GetContracts` provides available contracts.
3. `enrollment.GetPatientContractGroups` retrieves patient contract group assignments.

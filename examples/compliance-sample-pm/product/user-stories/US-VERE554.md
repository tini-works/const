## US-VERE554 — Correct enrollment form variant must be available per contract

| Field | Value |
|-------|-------|
| **ID** | US-VERE554 |
| **Traced from** | [VERE554](../compliances/SV/VERE554.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, VTG |

### User Story

As a patient, I want correct enrollment form variant is available per contract, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a Vertrag with a specific TE-Formular, when TE is created, then the correct form variant is selected

### Actual Acceptance Criteria

1. Implemented -- `contract.GetContracts` and `contract.GetContractById` retrieve contract definitions.
2. `contract.GetContractsHasFunctions` checks contract feature availability.
3. `enrollment.CreatePatientEnrollment` initiates enrollment.
4. `enrollment.PreviewForm` generates form previews.

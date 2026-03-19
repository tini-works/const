## US-VERE559 — Enrollment form variant per contract

| Field | Value |
|-------|-------|
| **ID** | US-VERE559 |
| **Traced from** | [VERE559](../compliances/SV/VERE559.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, VTG, FRM |

### User Story

As a patient, I want enrollment form variant per contract, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given different Verträge, when TE is created, then each Vertrag uses its specific form variant

### Actual Acceptance Criteria

1. Implemented -- `contract.GetContracts` and `contract.GetContractById` retrieve contract definitions.
2. `contract.GetContractsHasFunctions` checks feature availability.
3. `enrollment.CreatePatientEnrollment` initiates enrollment per contract.

## US-VERE1559 — Enrollment procedure type must be selectable per contract

| Field | Value |
|-------|-------|
| **ID** | US-VERE1559 |
| **Traced from** | [VERE1559](../compliances/SV/VERE1559.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, VTG, TNV |

### User Story

As a patient, I want enrollment procedure type is selectable per contract, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a Vertrag with multiple Einschreibeverfahren, when TE is created, then the correct procedure type is selectable

### Actual Acceptance Criteria

1. Implemented -- `enrollment.CreatePatientEnrollment` creates enrollment.
2. `contract.GetContracts` and `contract.GetContractsHasFunctions` provide contract configuration.

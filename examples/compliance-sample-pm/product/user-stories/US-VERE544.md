## US-VERE544 — Enrollment declaration full print variant

| Field | Value |
|-------|-------|
| **ID** | US-VERE544 |
| **Traced from** | [VERE544](../compliances/SV/VERE544.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, VTG |

### User Story

As a patient, I want enrollment declaration full print variant, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a contract-specific TE variant, when full print is requested, then the correct variant layout is used

### Actual Acceptance Criteria

1. Implemented -- `enrollment.PrintForm` and `enrollment.PrintMutipleForms` generate contract-specific forms.
2. `contract.GetContracts` and `contract.GetContractById` provide contract definitions for form generation.

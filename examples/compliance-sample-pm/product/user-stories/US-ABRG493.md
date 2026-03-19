## US-ABRG493 — Billing process controls per contract

| Field | Value |
|-------|-------|
| **ID** | US-ABRG493 |
| **Traced from** | [ABRG493](../compliances/SV/ABRG493.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | VTG, ABR |

### User Story

As a practice doctor, I want billing process controls per contract, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Selektivvertrag with billing controls, when Abrechnung runs, then contract-specific process controls are applied

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.PreConditionSvBilling` operation in `backend-core/app/app-core/api/billing/billing.d.go` returns `PreConditionSvBillingResponse` applying contract-specific pre-conditions before billing. Contract rules are loaded via `ContractApp.GetContractById` which includes `ContractRules` (excluded services, included diagnoses, doctor function types) per Selektivvertrag.

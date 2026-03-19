## US-ABRG454 — Billing process must be controllable per contract rules

| Field | Value |
|-------|-------|
| **ID** | US-ABRG454 |
| **Traced from** | [ABRG454](../compliances/SV/ABRG454.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want billing process is controllable per contract rules, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given contract-specific Abrechnungsregeln, when the billing process runs, then only contract-permitted operations are executed

### Actual Acceptance Criteria

1. Partially implemented. The `BillingApp.SubmitBillingToHpm` operation in `backend-core/app/app-core/api/billing/billing.d.go` submits billing per contract, and `ContractApp.GetContractById` in `backend-core/app/app-core/api/contract/contract.d.go` provides contract-specific rules including `ContractRules` with excluded services, included diagnoses, and doctor function types. The SV timeline validators in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/` enforce contract-specific rules (excluded services, included diagnoses, age, gender, number limits).

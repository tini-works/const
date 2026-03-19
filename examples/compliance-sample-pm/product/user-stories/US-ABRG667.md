## US-ABRG667 — System must perform comprehensive billing validation covering all contract-specific rules...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG667 |
| **Traced from** | [ABRG667](../compliances/SV/ABRG667.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | ABR, VTG |

### User Story

As a practice doctor, I want perform comprehensive billing validation covering all contract-specific rules via HPM, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given Abrechnungsdaten, when HPM validation runs, then all contract-specific rules are checked and results returned

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.TestSubmitBillings` and `BillingApp.SubmitBillingToHpm` operations in `backend-core/app/app-core/api/billing/billing.d.go` invoke HPM validation covering contract-specific rules. The SV validators in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/` apply comprehensive contract rules including: `IncludedDiagnoseValidator`, `ExcludedServiceValidator`, `AgeValidator`, `GenderValidator`, `NumberValidator`, `PreParticipationValidator`, `ConditionValidator`, and `CustodianServiceValidator`.

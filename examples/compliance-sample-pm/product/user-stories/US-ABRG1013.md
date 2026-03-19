## US-ABRG1013 — Pre-participation check variant

| Field | Value |
|-------|-------|
| **ID** | US-ABRG1013 |
| **Traced from** | [ABRG1013](../compliances/SV/ABRG1013.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | PAT, VTG, PM |

### User Story

As a practice doctor, I want pre-participation check variant, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a billing pre-check variant, when triggered, then the contract-specific participation verification logic is applied

### Actual Acceptance Criteria

1. Implemented. The `PreParticipationValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/preparticipation.validator.go` implements the pre-participation check variant using `ZifferartTyp` from the contract model. The `BillingApp.SubmitPreParticipateService` in `backend-core/app/app-core/api/billing/billing.d.go` supports the variant submission flow.

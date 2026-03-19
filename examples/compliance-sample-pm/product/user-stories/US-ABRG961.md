## US-ABRG961 — Pre-participation check variant

| Field | Value |
|-------|-------|
| **ID** | US-ABRG961 |
| **Traced from** | [ABRG961](../compliances/SV/ABRG961.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | TE, VTG |

### User Story

As a practice doctor, I want pre-participation check variant, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a variant participation check, when triggered during billing, then the contract-specific pre-check variant is applied

### Actual Acceptance Criteria

1. Implemented. The `PreParticipationValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/preparticipation.validator.go` supports variant participation checks using `ZifferartTyp` from the contract model. The `BillingApp.SubmitPreParticipateService` in `backend-core/app/app-core/api/billing/billing.d.go` handles the pre-participation variant via `PreParticipateServiceSubmissionRequest`.

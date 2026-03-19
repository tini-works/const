## US-ABRG958 — System must check pre-participation status before allowing billing

| Field | Value |
|-------|-------|
| **ID** | US-ABRG958 |
| **Traced from** | [ABRG958](../compliances/SV/ABRG958.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want check pre-participation status before allowing billing, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a billing attempt for a Selektivvertrag, when Teilnahmestatus is not active, then billing is blocked

### Actual Acceptance Criteria

1. Implemented. The `PreParticipationValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/preparticipation.validator.go` checks pre-participation (Teilnahme) status before allowing SV billing. The `BillingApp.SubmitPreParticipateService` and `ReSubmitPreParticipateService` operations in `backend-core/app/app-core/api/billing/billing.d.go` handle pre-participation service submissions.

## US-ABRG497 — Billing data must include required referral documentation for services that...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG497 |
| **Traced from** | [ABRG497](../compliances/SV/ABRG497.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | SVC, UBW, ABR |

### User Story

As a practice doctor, I want billing data include required referral documentation for services that require referrals, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Leistung requiring Überweisung, when billing data is generated, then referral documentation fields are included

### Actual Acceptance Criteria

1. Partially implemented. The `ScheinApp` in `backend-core/app/app-core/api/schein/` manages billing cases (Scheine) which can include referral (Ueberweisung) data. The `fav.referral_doctor.validator.go` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/` validates FAV referral doctor requirements. Full referral documentation field inclusion in billing data needs verification in the HPM builder (`backend-core/service/domains/internal/billing/hpm_next_builder/`).

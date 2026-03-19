## US-ABRG670 — Patient birth dates must be captured enabling accurate age calculation...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG670 |
| **Traced from** | [ABRG670](../compliances/SV/ABRG670.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want patient birth dates is captured enabling accurate age calculation for age-dependent billing rules, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Patient with Geburtsdatum, when age-dependent billing rules are evaluated, then age is calculated correctly from the birth date

### Actual Acceptance Criteria

1. Implemented. The `AgeValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/age.validator.go` evaluates age-dependent billing rules using `RegelAlterTyp` from the contract definition. Patient birth dates are available via `PatientProfileResponse.DateOfBirth` in the billing API and through the patient profile for accurate age calculation.

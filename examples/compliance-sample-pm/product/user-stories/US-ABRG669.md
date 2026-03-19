## US-ABRG669 — Chronic care flat-rate must require at least one confirmed permanent...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG669 |
| **Traced from** | [ABRG669](../compliances/SV/ABRG669.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want chronic care flat-rate require at least one confirmed permanent diagnosis — billing is blocked if only acute diagnoses exist as permanent, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Chronikerpauschale billed, when only akute Diagnosen exist as Dauerdiagnose, then billing is blocked with a diagnosis-type error

### Actual Acceptance Criteria

1. Implemented. The `IncludedDiagnoseValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/included.diagnose.validator.go` enforces that chronic care flat-rate services require at least one confirmed permanent diagnosis. The contract rules include `Permanent` flag and `Certainty` requirements in `IIncludedDiagnoses` at `backend-core/app/app-core/api/contract/contract.d.go`. Billing is blocked if only acute diagnoses exist as Dauerdiagnose.

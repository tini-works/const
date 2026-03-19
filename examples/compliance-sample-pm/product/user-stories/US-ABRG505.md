## US-ABRG505 — System must verify diagnosis prerequisites for service P3 (code 0003)

| Field | Value |
|-------|-------|
| **ID** | US-ABRG505 |
| **Traced from** | [ABRG505](../compliances/SV/ABRG505.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | DX, SVC |

### User Story

As a practice doctor, I want verify diagnosis prerequisites for service P3 (code 0003), so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given Leistung P3 (code 0003) documented, when diagnosis prerequisites are missing, then validation blocks billing

### Actual Acceptance Criteria

1. Implemented. The `IncludedDiagnoseValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/included.diagnose.validator.go` enforces diagnosis prerequisites for SV service codes including P3 (code 0003). It validates against `RegelDiagnoseeinschlussTyp` rules from the contract definition, checking required diagnoses by code, certainty, and permanence.

## US-ABRG678 — System must apply special validation rules for diagnosis requirements when...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG678 |
| **Traced from** | [ABRG678](../compliances/SV/ABRG678.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want apply special validation rules for diagnosis requirements when service P3 is documented, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given Leistung P3, when diagnosis validation runs, then P3-specific diagnosis requirements are enforced

### Actual Acceptance Criteria

1. Implemented. The `IncludedDiagnoseValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/included.diagnose.validator.go` enforces P3-specific diagnosis requirements using `RegelDiagnoseeinschlussTyp` rules from the contract definition. The `BillingApp.AnalyzeForP4Diseases` in `backend-core/app/app-core/api/billing/billing.d.go` also provides disease analysis for related P4 service codes.

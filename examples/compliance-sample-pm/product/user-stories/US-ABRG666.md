## US-ABRG666 — System must include all acute and permanent diagnoses documented during...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG666 |
| **Traced from** | [ABRG666](../compliances/SV/ABRG666.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want include all acute and permanent diagnoses documented during the quarter in billing data, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given akute and Dauerdiagnosen in a Quartal, when billing data is generated, then both types are included

### Actual Acceptance Criteria

1. Implemented. The encounter model at `backend-core/service/domains/repos/app_core/patient_encounter/encounter_common.d.go` distinguishes acute and permanent (Dauerdiagnose) diagnosis types with certainty indicators. The `DiagnoseValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/diagnose.validator.go` processes both types, and the billing builder includes all quarter-relevant diagnoses in billing output.

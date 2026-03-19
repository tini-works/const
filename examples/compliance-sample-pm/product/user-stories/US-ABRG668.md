## US-ABRG668 — System must flag diagnoses that lack required specificity or terminal...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG668 |
| **Traced from** | [ABRG668](../compliances/SV/ABRG668.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | DX, ABR |

### User Story

As a practice doctor, I want flag diagnoses that lack required specificity or terminal ICD codes, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a non-terminal ICD-Code in billing data, when validation runs, then it is flagged as insufficiently specific

### Actual Acceptance Criteria

1. Implemented. The `SdicdValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/sdicd.validator.go` validates ICD code specificity and terminal status. It checks codes against the SDICD catalog for required precision and flags non-terminal ICD codes as insufficiently specific.

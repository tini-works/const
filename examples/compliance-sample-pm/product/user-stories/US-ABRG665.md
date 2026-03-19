## US-ABRG665 — System must ensure all diagnosed conditions are included in billing...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG665 |
| **Traced from** | [ABRG665](../compliances/SV/ABRG665.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | DX, BF |

### User Story

As a practice doctor, I want ensure all diagnosed conditions are included in billing cases, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Behandlungsfall with documented Diagnosen, when billing is generated, then all Diagnosen are included in the Abrechnungsfall

### Actual Acceptance Criteria

1. Implemented. The `DiagnoseValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/diagnose.validator.go` validates that all documented diagnoses are included in billing cases. The Schein model in `backend-core/service/domains/api/schein_common/schein_common.d.go` links diagnoses to billing cases, and the HPM builder at `backend-core/service/domains/internal/billing/hpm_next_builder/builder.go` includes all diagnoses in the billing data.

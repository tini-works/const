## US-ABRG1415 — System must verify OPS code completeness and validity against contract...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG1415 |
| **Traced from** | [ABRG1415](../compliances/SV/ABRG1415.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | OPS, VTG, ABR |

### User Story

As a practice doctor, I want verify OPS code completeness and validity against contract specifications during billing, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given billing validation, when OPS codes are checked against Vertragsspezifikation, then incomplete or invalid codes are flagged

### Actual Acceptance Criteria

1. Implemented. The `KvServiceIncludedOpsValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.include.ops.validator.go` verifies OPS code completeness and validity against contract/catalog specifications during billing. The SDOPS service at `backend-core/service/domains/sdops/sdops_service/sdops_service.go` provides the reference catalog for validation.

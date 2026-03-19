## US-ABRG997 — System must validate OPS codes against contract-specific catalog and reject...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG997 |
| **Traced from** | [ABRG997](../compliances/SV/ABRG997.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want validate OPS codes against contract-specific catalog and reject invalid codes, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given an OPS-Code in billing data, when it is not in the contract-specific Katalog, then validation rejects it

### Actual Acceptance Criteria

1. Implemented. The `KvServiceIncludedOpsValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.include.ops.validator.go` validates OPS codes against catalog specifications. The SDOPS service at `backend-core/service/domains/sdops/sdops_service/sdops_service.go` provides the contract/catalog-specific OPS reference data. Invalid or non-matching OPS codes are rejected during validation.

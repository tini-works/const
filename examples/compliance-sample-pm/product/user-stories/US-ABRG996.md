## US-ABRG996 — System must flag missing mandatory OPS procedure codes in billing...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG996 |
| **Traced from** | [ABRG996](../compliances/SV/ABRG996.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | OPS, BF |

### User Story

As a practice doctor, I want flag missing mandatory OPS procedure codes in billing cases requiring them, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a billing case requiring OPS, when OPS is missing, then validation flags a mandatory-OPS error

### Actual Acceptance Criteria

1. Implemented. The `KvServiceIncludedOpsValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.include.ops.validator.go` validates mandatory OPS procedure codes in billing cases. It checks against `BedingungTyp` rules from the SDEBM catalog and flags missing OPS codes as validation errors.

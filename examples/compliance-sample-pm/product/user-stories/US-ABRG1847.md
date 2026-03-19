## US-ABRG1847 — System must ensure additional information fields required for specific services...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG1847 |
| **Traced from** | [ABRG1847](../compliances/SV/ABRG1847.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want ensure additional information fields required for specific services are completed, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Leistung requiring Zusatzinformationen, when the fields are empty, then validation blocks submission

### Actual Acceptance Criteria

1. Implemented. The `AdditionalInfoValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/additionalInfo.validator.go` validates that additional information fields (Zusatzinformationen) required for specific services are completed. The SDEBM additional field rule configuration at `backend-core/service/domains/repos/masterdata_repo/sdebm/additional_field/rule_config.go` defines which services require additional fields, and validation blocks submission when they are empty.

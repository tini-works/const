## US-ABRG999 — System must flag missing billing justification documentation for services requiring...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG999 |
| **Traced from** | [ABRG999](../compliances/SV/ABRG999.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want flag missing billing justification documentation for services requiring it, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Leistung requiring Begründung, when justification text is missing, then validation flags it

### Actual Acceptance Criteria

1. Implemented. The `AdditionalInfoValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/additionalInfo.validator.go` flags missing billing justification (Begruendung) documentation for services requiring it. The SDEBM additional field rule configuration at `backend-core/service/domains/repos/masterdata_repo/sdebm/additional_field/rule_config.go` defines which services require justification text.

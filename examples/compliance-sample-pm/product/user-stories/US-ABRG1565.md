## US-ABRG1565 — Billing validation rule

| Field | Value |
|-------|-------|
| **ID** | US-ABRG1565 |
| **Traced from** | [ABRG1565](../compliances/SV/ABRG1565.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | ABR, VTG |

### User Story

As a practice doctor, I want billing validation rule, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given Abrechnungsvalidierung, when contract-specific rules are applied, then violations are reported with rule references

### Actual Acceptance Criteria

1. Implemented. The timeline validation framework in `backend-core/service/timeline_validation/service/validation_timeline/validations/` applies comprehensive billing validation rules. SV-specific validators in `service_code/sv/` include: `IncludedDiagnoseValidator`, `ExcludedServiceValidator`, `ExcludedDiagnoseValidator`, `AgeValidator`, `GenderValidator`, `NumberValidator`, `ConditionValidator`, `PreParticipationValidator`, and `ABRG664Validator`. KV validators in `service_code/kv/precondition/` cover OPS, SDKV, age, gender, and number rules. Violations are reported with rule references.

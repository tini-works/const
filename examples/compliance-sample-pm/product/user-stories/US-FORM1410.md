## US-FORM1410 — Form validation per contract

| Field | Value |
|-------|-------|
| **ID** | US-FORM1410 |
| **Traced from** | [FORM1410](../compliances/SV/FORM1410.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want form validation per contract, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a Vertragsformular, when submitted, then contract-specific validation rules are applied before acceptance

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.BuildBundleAndValidation` endpoint accepts a `Prescribe` payload with `PrintOption` and returns `EAUValidation`, implementing contract-scoped form validation before acceptance
2. The `BuildBundleAndValidationRequest` includes `Prescribe` (with form and patient data) and `PrintOption` to validate against contract-specific rules
3. The `BuildBundleAndValidationResponse` returns `EAUValidation` results indicating validation pass/fail per contract rules

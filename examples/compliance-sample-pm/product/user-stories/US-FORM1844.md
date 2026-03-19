## US-FORM1844 — Electronic sick note (eAU) must be validated

| Field | Value |
|-------|-------|
| **ID** | US-FORM1844 |
| **Traced from** | [FORM1844](../compliances/SV/FORM1844.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT |

### User Story

As a practice staff (MFA), I want electronic sick note (eAU) is validated, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given an eAU being created, when validation runs, then all mandatory eAU fields are checked before transmission

### Actual Acceptance Criteria

**Status: Implemented**

1. The `EAUApp.CreateEAU` endpoint creates an electronic sick note (eAU) with mandatory field validation including `patientId`, `scheinId`, `prescribeDate`, and `eauType`
2. The `FormAPP.BuildBundleAndValidation` endpoint validates the eAU bundle before transmission, returning `EAUValidation` results
3. The `EAUApp.SignAndSendEAU` endpoint handles signing and transmission after validation passes
4. The `EAUApp.CancelEAU` and `EAUApp.RemoveEAU` endpoints support the full eAU lifecycle management
5. The `EAUApp.Print` endpoint generates printable output of the validated eAU

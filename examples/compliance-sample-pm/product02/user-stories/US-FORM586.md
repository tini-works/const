## US-FORM586 — Contractual forms must be manageable

| Field | Value |
|-------|-------|
| **ID** | US-FORM586 |
| **Traced from** | [FORM586](../compliances/SV/FORM586.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want contractual forms is manageable, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given Vertragsformulare defined for a Selektivvertrag, when the user opens form management, then all contract forms are listed and selectable

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetAllForms` endpoint returns all available forms in the system
2. The `FormAPP.GetForms` endpoint accepts `contractId`, `oKV`, `ikNumber`, and `chargeSystemId` parameters to filter forms by selective contract
3. The `GetFormsResponse` returns a list of `common.Form` objects, each carrying `formType` and `formName` so the client can list and select contract forms

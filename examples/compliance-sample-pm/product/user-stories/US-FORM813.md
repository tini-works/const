## US-FORM813 — Form feature per contract

| Field | Value |
|-------|-------|
| **ID** | US-FORM813 |
| **Traced from** | [FORM813](../compliances/SV/FORM813.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want form feature per contract, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given contract-specific form configuration, when the user accesses forms, then only the contract's form set is available

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForms` endpoint filters available forms by `contractId`, `oKV`, `ikNumber`, and `chargeSystemId` to return only the contract's form set
2. The `FormAPP.GetAllForms` endpoint returns the complete form catalog for comparison

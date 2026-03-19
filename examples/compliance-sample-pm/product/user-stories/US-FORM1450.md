## US-FORM1450 — Form feature per contract

| Field | Value |
|-------|-------|
| **ID** | US-FORM1450 |
| **Traced from** | [FORM1450](../compliances/SV/FORM1450.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, VTG |

### User Story

As a practice staff (MFA), I want form feature per contract, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a contract's form feature set, when the user accesses forms, then only contract-enabled forms are available

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForms` endpoint filters forms by `contractId`, `oKV`, `ikNumber`, `chargeSystemId`, and `moduleChargeSystemId` to return only contract-enabled forms
2. The `FormAPP.GetAllForms` endpoint provides the complete form catalog for reference

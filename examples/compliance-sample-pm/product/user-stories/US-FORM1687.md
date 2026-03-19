## US-FORM1687 — Form feature per contract

| Field | Value |
|-------|-------|
| **ID** | US-FORM1687 |
| **Traced from** | [FORM1687](../compliances/SV/FORM1687.md) |
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

1. Given a contract with form features, when the user opens form view, then only the contract's form set is shown

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForms` endpoint filters forms by `contractId`, `oKV`, `ikNumber`, and `chargeSystemId` to return only the contract's form set
2. The `FormAPP.GetAllForms` endpoint provides the full form catalog for reference

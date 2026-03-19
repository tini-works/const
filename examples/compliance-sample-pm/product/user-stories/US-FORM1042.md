## US-FORM1042 — Form feature per contract

| Field | Value |
|-------|-------|
| **ID** | US-FORM1042 |
| **Traced from** | [FORM1042](../compliances/SV/FORM1042.md) |
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

1. Given a contract defining form features, when form access is attempted, then only enabled forms are shown

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForms` endpoint accepts `contractId`, `oKV`, `ikNumber`, `chargeSystemId`, and `moduleChargeSystemId` to filter forms per contract definition
2. The `FormAPP.GetAllForms` endpoint provides the full form catalog; contract-scoped filtering ensures only enabled forms are shown

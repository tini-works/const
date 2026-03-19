## US-FORM632 — Form feature per contract

| Field | Value |
|-------|-------|
| **ID** | US-FORM632 |
| **Traced from** | [FORM632](../compliances/SV/FORM632.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want form feature per contract, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a Vertrag with specific form features, when form management is opened, then only contract-enabled forms are available

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetAllForms` endpoint returns all forms, and `FormAPP.GetForms` filters by `contractId` to show only contract-enabled forms
2. The `GetFormsRequest` includes `contractId`, `chargeSystemId`, and `moduleChargeSystemId` fields to scope forms to the specific contract's feature set

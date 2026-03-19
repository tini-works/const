## US-FORM513 — When printing a medication or vaccine prescription (KV or BTM...

| Field | Value |
|-------|-------|
| **ID** | US-FORM513 |
| **Traced from** | [FORM513](../compliances/SV/FORM513.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want when printing a medication or vaccine prescription (KV or BTM recipe) for a contract participant, the Vertragssoftware apply contract-specific printing rules, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a contract participant, when a medication/vaccine prescription is printed on KV or BTM recipe, then contract-specific printing rules are applied

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the prescription form (KV via `Muster_16`/`Muster_16A`, BTM via `Btm_Rezept_Print`) scoped by contract via `contractId` parameter
2. The `MedicineApp.Prescribe` endpoint applies contract-specific printing rules when generating medication/vaccine prescriptions
3. The `FormAPP.Print` and `FormAPP.PrintPlainPdf` endpoints produce PDF output with contract-specific formatting applied
4. The `HasSupportForm907()` helper on `FormName` returns true for `KREZ` (Muster_16) and `BTM` form types, confirming contract-aware prescription rule support

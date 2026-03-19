## US-FORM907 — When printing a medication or vaccine prescription (KV or BTM...

| Field | Value |
|-------|-------|
| **ID** | US-FORM907 |
| **Traced from** | [FORM907](../compliances/SV/FORM907.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, RZP, VTG |

### User Story

As a practice staff (MFA), I want when printing a medication or vaccine prescription (KV or BTM recipe) for a contract participant, the Vertragssoftware apply contract-specific printing rules, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a contract participant, when a medication/vaccine prescription is printed on KV or BTM recipe, then contract-specific printing rules are applied

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves prescription forms (KV via `Muster_16`/`Muster_16A`, BTM via `Btm_Rezept_Print`) scoped by contract
2. The `MedicineApp.Prescribe` endpoint applies contract-specific printing rules during medication/vaccine prescription generation
3. The `FormName.HasSupportForm907()` method explicitly returns true for `KREZ` (Muster_16) and `BTM` form types, confirming this requirement is code-recognized
4. The `FormAPP.Print` and `FormAPP.PrintPlainPdf` endpoints produce PDF output with contract-specific formatting

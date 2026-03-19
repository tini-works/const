## US-FORM1447 — When opening Muster 10 or Muster 10A lab referral forms...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1447 |
| **Traced from** | [FORM1447](../compliances/SV/FORM1447.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want when opening Muster 10 or Muster 10A lab referral forms for an active HZV/FaV/BV/IV participant, the Vertragssoftware display the hint text provided in the AKA-Basisdatei for Hinweistexte, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given an active HZV/FaV/BV/IV participant, when Muster 10 or 10A is opened, then the AKA-Basisdatei Hinweistext for lab referrals is displayed

### Actual Acceptance Criteria

**Status: Partially implemented**

1. Muster 10 and Muster 10A are defined as `FormName` constants (`Muster_10`, `Muster_10A`) and retrievable via `FormAPP.GetForm`
2. The `FormType_contract_hint` FormType constant exists in the domain model for Hinweistext infrastructure
3. The actual hint text display from AKA-Basisdatei Hinweistexte when Muster 10/10A is opened for an active HZV/FaV/BV/IV participant is a client-side UI concern -- no backend endpoint specifically returns the Hinweistext for lab referral forms

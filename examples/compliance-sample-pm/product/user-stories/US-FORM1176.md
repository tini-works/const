## US-FORM1176 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1176 |
| **Traced from** | [FORM1176](../compliances/SV/FORM1176.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the contract-specific 'Befundbogen Grundversorgung' form per AKA-Basisdatei rules as Volldruck, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the 'Befundbogen Grundversorgung' form is opened, then it can be filled, printed as Volldruck per AKA template, and saved to the patient

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Befundbogen Grundversorgung form (defined as `AOK_FA_OC_BW_BKK_FA_OC_BW_Befundbogen_Grundversorgung_V3` FormName constant per AKA-Basisdatei)
2. The `FormAPP.PrescribeV2` endpoint saves the form to the patient record with timeline integration
3. The `FormAPP.Print` endpoint generates Volldruck PDF output per the AKA template

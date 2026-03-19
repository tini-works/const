## US-FORM1236 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1236 |
| **Traced from** | [FORM1236](../compliances/SV/FORM1236.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the contract-specific 'GDK Antragsformular' form per AKA-Basisdatei rules as Volldruck, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the 'GDK Antragsformular' form is opened, then it can be filled, printed as Volldruck per AKA template, and saved to the patient

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the GDK Antragsformular form (defined as `AOK_FA_NPPP_BW_GDK_Antragsformular_V6`, `AOK_FA_BW_GDK_Antragsformular_DF_V4`, `BKK_BOSCH_FA_BW_GDK_Antragsformular_V4`, `BKK_VAG_FA_PT_BW_GDK_Antragsformular_V3`, `BKK_GWQ_FA_PT_BW_GDK_Antragsformular_V2` FormName constants per AKA-Basisdatei)
2. The `FormAPP.PrescribeV2` endpoint saves the form to the patient record with timeline integration
3. The `FormAPP.Print` endpoint generates Volldruck PDF output per the AKA template

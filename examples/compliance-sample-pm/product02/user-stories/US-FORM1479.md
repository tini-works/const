## US-FORM1479 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1479 |
| **Traced from** | [FORM1479](../compliances/SV/FORM1479.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the 'Ueberleitungsmanagement' form per AKA-Basisdatei rules, supporting both Volldruck and Formulardruck; printing before filling all mandatory fields and intermediate saving is possible, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the 'Ueberleitungsmanagement' form is opened, then it can be filled, printed (Volldruck or Formulardruck), and saved
2. Given mandatory fields are not yet filled, then printing is still allowed
3. Given intermediate state, then saving is possible

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Ueberleitungsmanagement form (defined as `AOK_SH_HZV_Ueberleitungsmanagement_V3`, `Ueberleitungsbogen_AOK_KBS_NO_WL_V2`, `RV_KBS_SN_HZV_Ueberleitungsmanagement_Ueberleitungsbogen_V3` FormName constants per AKA-Basisdatei)
2. The `FormAPP.PrescribeV2` endpoint supports intermediate saving of the form before all mandatory fields are filled
3. The `FormAPP.Print` endpoint supports both Volldruck and Formulardruck output modes
4. Printing before all mandatory fields are filled is allowed via the `PrintPlainPdf` endpoint which does not enforce field validation

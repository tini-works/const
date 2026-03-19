## US-FORM814 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM814 |
| **Traced from** | [FORM814](../compliances/SV/FORM814.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the 'Schnellinformation zur Patientenbegleitung' form per AKA-Basisdatei rules, printed as Volldruck matching the provided template, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the 'Schnellinformation zur Patientenbegleitung' is opened, then the form can be filled, printed as Volldruck per AKA template, and saved to the patient

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Schnellinformation zur Patientenbegleitung form (defined as `BKK_VAG_BW_Schnellinformation_Patientenbegleitung_V5`, `BKK_BOSCH_BW_Schnellinfo_Patientenbegleitung_V6`, `BKK_VAG_HE_Schnellinformation_Patientenbegleitung_V1`, and `BKK_BY_HZV_Schnellinfo_Patientenbegleitung_V6` FormName constants per AKA-Basisdatei)
2. The `FormAPP.Print` endpoint generates Volldruck PDF output matching the AKA template
3. The `FormAPP.PrescribeV2` endpoint saves the form to the patient record via timeline integration

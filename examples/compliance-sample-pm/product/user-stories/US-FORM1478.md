## US-FORM1478 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1478 |
| **Traced from** | [FORM1478](../compliances/SV/FORM1478.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the contract-specific 'Uebertragung Honorar Anaesthesist' form per AKA-Basisdatei rules as Volldruck, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the 'Uebertragung Honorar Anaesthesist' form is opened, then it can be filled, printed as Volldruck per AKA template, and saved to the patient

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Uebertragung Honorar Anaesthesist form (defined as `AOK_FA_URO_BW_BKK_FA_URO_BW_Uebertragung_Honorar_Anaesthesist_V4` and `AOK_FA_OC_BW_BKK_FA_OC_BW_Uebertragung_Honorar_Anaesthesist_V5` FormName constants per AKA-Basisdatei)
2. The `FormAPP.PrescribeV2` endpoint saves the form to the patient record with timeline integration
3. The `FormAPP.Print` endpoint generates Volldruck PDF output per the AKA template

## US-FORM1238 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1238 |
| **Traced from** | [FORM1238](../compliances/SV/FORM1238.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the contract-specific 'Beratungsbogen zur Einbindung der Patientenbegleitung' form per AKA-Basisdatei rules as Volldruck, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the 'Beratungsbogen zur Einbindung der Patientenbegleitung' form is opened, then it can be filled, printed as Volldruck per AKA template, and saved to the patient

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Beratungsbogen zur Einbindung der Patientenbegleitung form (defined as `BKK_BOSCH_Beratungsbogen_Einbindung_PBG_V10` FormName constant per AKA-Basisdatei)
2. The `FormAPP.PrescribeV2` endpoint saves the form to the patient record with timeline integration
3. The `FormAPP.Print` endpoint generates Volldruck PDF output per the AKA template

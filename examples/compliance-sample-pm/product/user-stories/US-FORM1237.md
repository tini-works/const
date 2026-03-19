## US-FORM1237 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1237 |
| **Traced from** | [FORM1237](../compliances/SV/FORM1237.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the contract-specific 'Beratungsbogen zur Einbindung des Sozialen Dienstes' form per AKA-Basisdatei rules as Volldruck, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the 'Beratungsbogen zur Einbindung des Sozialen Dienstes' form is opened, then it can be filled, printed as Volldruck per AKA template, and saved to the patient

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Beratungsbogen zur Einbindung des Sozialen Dienstes form (defined as `AOK_BW_Beratungsbogen_Einbindung_SD_V7` FormName constant per AKA-Basisdatei)
2. The `FormAPP.PrescribeV2` endpoint saves the form to the patient record with timeline integration
3. The `FormAPP.Print` endpoint generates Volldruck PDF output per the AKA template

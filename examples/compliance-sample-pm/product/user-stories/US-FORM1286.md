## US-FORM1286 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1286 |
| **Traced from** | [FORM1286](../compliances/SV/FORM1286.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT, DX |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the 'Praeventionsverordnung' form, which auto-open when a confirmed diagnosis from the AKA-Basisdatei Diagnosenliste is first documented for the patient in the quarter, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a first-in-quarter confirmed diagnosis from the AKA Diagnosenliste, when documented, then the 'Praeventionsverordnung' form auto-opens
2. Given the form, when filled, then it can be printed and saved per AKA rules

### Actual Acceptance Criteria

**Status: Partially implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Praeventionsverordnung form (defined as `BKK_BOSCH_VAG_BW_Praeventionsverordnung_V1` FormName constant per AKA-Basisdatei)
2. The `FormAPP.PrescribeV2` endpoint saves the form and `FormAPP.Print` generates the printable PDF per AKA rules
3. The auto-open behavior when a confirmed diagnosis from the AKA-Basisdatei Diagnosenliste is first documented in the quarter is a client-side UI concern -- no backend trigger exists for automatic form opening based on diagnosis events

## US-FORM635 — The Vertragssoftware must provide the FaV cover letter (Begleitschreiben) form...

| Field | Value |
|-------|-------|
| **ID** | US-FORM635 |
| **Traced from** | [FORM635](../compliances/SV/FORM635.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT, DX |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide the FaV cover letter (Begleitschreiben) form per AKA-Basisdatei, allowing the user to save it to the patient record and auto-fill permanent diagnoses and allergy fields from the patient record while keeping other fields manually editable, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a FaV patient, when the Begleitschreiben is opened, then it can be saved to the patient record
2. Given stored Dauerdiagnosen and allergies exist, then those fields are pre-filled
3. Given other fields, then they remain manually editable

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Begleitschreiben FaV form (defined as `Begleitschreiben_FaV_V4` FormName constant) with patient data loaded
2. The `FormAPP.PrescribeV2` endpoint saves the form to the patient record, returning `timelineId` for patient timeline integration
3. The `FormAPP.Print` endpoint generates the printable Begleitschreiben with Dauerdiagnosen and allergy fields auto-filled from the patient record
4. Other fields remain editable via the form's `formSetting` JSON payload in `PrintPlainPdfRequest`

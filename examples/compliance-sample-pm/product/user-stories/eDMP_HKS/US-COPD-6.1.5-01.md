## US-COPD-6.1.5-01 — Anamnese must capture Koerpergroesse, Koerpergewicht, Raucher status, and Blutdruck

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.5-01 |
| **Traced from** | [COPD-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.5-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Koerpergroesse (cm), Koerpergewicht (kg), Raucher status (Ja/Nein/Nicht erhoben), and Blutdruck systolisch/diastolisch (mmHg) in the Anamnese section, so that the patient's basic physical data is recorded per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD documentation is opened, when Anamnese is entered, then fields for Koerpergroesse (cm), Koerpergewicht (kg), Raucher (Ja/Nein/Nicht erhoben), and Blutdruck systolisch/diastolisch (mmHg) are available
2. Given values are outside plausible ranges, when saved, then a validation warning is displayed
3. Given mandatory fields are not filled, when the form is submitted, then a mandatory field error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists COPD Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the COPD plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "COPD"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the COPD XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

## US-COPD-6.1.5-02 — Anamnese must capture COPD-specific Begleiterkrankungen

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.5-02 |
| **Traced from** | [COPD-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.5-02.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to select COPD-specific Begleiterkrankungen from the defined value set in the Anamnese section, so that comorbidities relevant to COPD management are documented per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Anamnese form is displayed, when Begleiterkrankungen is selected, then the COPD-specific comorbidity options are available
2. Given "Keine" is selected, when another comorbidity is also selected, then a validation error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists COPD Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the COPD plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "COPD"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the COPD XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

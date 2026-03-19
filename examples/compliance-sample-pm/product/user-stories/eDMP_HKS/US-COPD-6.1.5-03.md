## US-COPD-6.1.5-03 — Anamnese must capture Aktueller FEV1-Wert (%)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.5-03 |
| **Traced from** | [COPD-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.5-03.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the current FEV1 value (Aktueller FEV1-Wert) as a percentage in the Anamnese section, so that lung function is monitored per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Anamnese form is displayed, when FEV1-Wert is entered, then the field accepts a percentage value
2. Given the FEV1 value is outside plausible range (0-150%), when saved, then a validation warning is displayed

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists COPD Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the COPD plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "COPD"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the COPD XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

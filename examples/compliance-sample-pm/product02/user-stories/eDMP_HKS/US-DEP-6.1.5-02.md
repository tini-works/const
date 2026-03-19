## US-DEP-6.1.5-02 — When a doctor documents eDMP Depression anamnesis, PHQ-9 severity assessment must be captured

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.5-02 |
| **Traced from** | [DEP-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.5-02.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the Depression severity assessment using the PHQ-9 instrument, so that the degree of depression is systematically recorded per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the anamnesis section is displayed, then a PHQ-9 assessment field is available
2. Given the PHQ-9 score is entered, when the XML is generated, then the severity value is encoded in the correct observation element
3. Given the PHQ-9 score is outside the valid range (0-27), when validation is triggered, then an error is displayed

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Depression Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Depression plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "DEPRESSION"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Depression XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

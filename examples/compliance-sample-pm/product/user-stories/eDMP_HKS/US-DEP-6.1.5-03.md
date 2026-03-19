## US-DEP-6.1.5-03 — When a doctor documents eDMP Depression anamnesis, comorbidities must be documented

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.5-03 |
| **Traced from** | [DEP-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.5-03.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document comorbidities in the Depression anamnesis section, so that relevant Begleiterkrankungen are recorded per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the anamnesis section is displayed, then comorbidity fields are available
2. Given comorbidities are documented, when the XML is generated, then each comorbidity is encoded in the correct element

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Depression Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Depression plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "DEPRESSION"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Depression XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

## US-BK-6.1.5-01 — Practice doctor must document Tumor staging data in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-BK-6.1.5-01 |
| **Traced from** | [BK-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-6.1.5-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Tumor staging data in the Anamnese section of the eDMP Brustkrebs documentation, so that tumour classification data is captured for breast cancer staging and treatment planning.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Anamnese is documented, when Tumor staging is recorded, then the required staging fields (TNM classification) are filled
2. Given staging data is incomplete, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Brustkrebs Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Brustkrebs plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "BRUSTKREBS"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Brustkrebs XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

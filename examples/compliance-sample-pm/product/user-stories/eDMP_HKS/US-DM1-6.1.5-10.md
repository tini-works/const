## US-DM1-6.1.5-10 — Practice doctor must document Injektionsstellen bei Insulintherapie as Unauffaellig, Auffaellig, or Nicht untersucht

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.5-10 |
| **Traced from** | [DM1-6.1.5-10](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.5-10.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Injektionsstellen bei Insulintherapie as Unauffaellig, Auffaellig, or Nicht untersucht in the Anamnese section, so that injection site status is captured for insulin therapy quality monitoring.

### Acceptance Criteria

1. Given an eDMP DM1 Anamnese is documented, when Injektionsstellen is recorded, then exactly one of Unauffaellig, Auffaellig, or Nicht untersucht is selected
2. Given no value is selected, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Diabetes mellitus Typ 1 Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Diabetes mellitus Typ 1 plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "DM1"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Diabetes mellitus Typ 1 XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

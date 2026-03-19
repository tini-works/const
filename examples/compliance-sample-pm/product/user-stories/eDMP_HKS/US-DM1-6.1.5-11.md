## US-DM1-6.1.5-11 — Practice doctor must document Intervall kuenftige Fussinspektionen ab 18. Lebensjahr

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.5-11 |
| **Traced from** | [DM1-6.1.5-11](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.5-11.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the interval for future foot inspections (ab 18. Lebensjahr) as Jaehrlich, alle 6 Monate, or alle 3 Monate oder haeufiger, so that the planned foot inspection frequency is documented for patients aged 18 and over.

### Acceptance Criteria

1. Given an eDMP DM1 Anamnese is documented for a patient aged 18 or older, when Intervall kuenftige Fussinspektionen is recorded, then exactly one of Jaehrlich, alle 6 Monate, or alle 3 Monate oder haeufiger is selected
2. Given the patient is under 18 years, when the field is presented, then it may be omitted or marked as not applicable
3. Given no value is selected for an eligible patient, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Diabetes mellitus Typ 1 Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Diabetes mellitus Typ 1 plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "DM1"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Diabetes mellitus Typ 1 XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

## US-ASTH-6.1.5-03 — Anamnese must capture Begleiterkrankungen as multi-select (Keine/Adipositas/Allergische Rhinitis/Konjunktivitis/Andere)

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.5-03 |
| **Traced from** | [ASTH-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.5-03.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to select Begleiterkrankungen from a multi-select list (Keine, Adipositas, Allergische Rhinitis, Konjunktivitis, Andere) in the Anamnese section, so that comorbidities are documented per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when Begleiterkrankungen is selected, then multiple values can be chosen from Keine, Adipositas, Allergische Rhinitis, Konjunktivitis, Andere
2. Given "Keine" is selected, when another comorbidity is also selected, then a validation error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Asthma Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Asthma plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "ASTHMA"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Asthma XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

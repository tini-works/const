## US-ASTH-6.1.5-02 — Anamnese must capture Blutdruck systolisch and diastolisch in mmHg

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.5-02 |
| **Traced from** | [ASTH-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.5-02.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Blutdruck systolisch and diastolisch values in mmHg in the Anamnese section, so that blood pressure is recorded as required by the eDMP Asthma specification.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is opened, when Anamnese is entered, then fields for systolisch and diastolisch Blutdruck in mmHg are available
2. Given systolisch is less than diastolisch, when saved, then a plausibility warning is displayed

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Asthma Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Asthma plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "ASTHMA"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Asthma XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

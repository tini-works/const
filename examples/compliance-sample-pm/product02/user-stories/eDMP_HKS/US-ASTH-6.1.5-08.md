## US-ASTH-6.1.5-08 — Anamnese must capture Aktueller FEV1-Wert (%) measured at least every 12 months

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.5-08 |
| **Traced from** | [ASTH-6.1.5-08](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.5-08.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the current FEV1 value (Aktueller FEV1-Wert) as a percentage, measured at least every 12 months, so that lung function is monitored per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when FEV1-Wert is entered, then the field accepts a percentage value
2. Given more than 12 months have elapsed since the last FEV1 measurement, when the form is opened, then a reminder is displayed to perform a new measurement
3. Given the FEV1 value is outside plausible range (0-150%), when saved, then a validation warning is displayed

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Asthma Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Asthma plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "ASTHMA"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Asthma XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

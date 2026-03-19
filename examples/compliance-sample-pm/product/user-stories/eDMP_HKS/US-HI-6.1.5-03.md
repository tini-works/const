## US-HI-6.1.5-03 — When a doctor documents eDMP HI anamnesis, ejection fraction data must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.5-03 |
| **Traced from** | [HI-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.5-03.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the ejection fraction in the HI anamnesis section, so that the left ventricular function is recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then an ejection fraction field is available
2. Given the ejection fraction value is entered, when the XML is generated, then the value is encoded in the correct observation element
3. Given the ejection fraction is outside the valid range, when validation is triggered, then an error is displayed

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Herzinsuffizienz Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Herzinsuffizienz plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "HERZINSUFFIZIENZ"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Herzinsuffizienz XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

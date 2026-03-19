## US-HI-6.1.5-04 — When a doctor documents eDMP HI anamnesis, HI-specific Begleiterkrankungen must be documented

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.5-04 |
| **Traced from** | [HI-6.1.5-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.5-04.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document HI-specific comorbidities (Begleiterkrankungen) in the anamnesis section, so that relevant accompanying diseases are recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then HI-specific comorbidity fields are available
2. Given comorbidities are documented, when the XML is generated, then each Begleiterkrankung is encoded in the correct HI-specific element

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint (NATS topic `api.app.app_core.EDMPApp.SaveDocumentationOverview`) persists Herzinsuffizienz Anamnese/clinical data fields submitted in the `DocumentationOverview.fields` array with the correct field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each clinical data field against the Herzinsuffizienz plausibility catalog; out-of-range or missing mandatory values produce `FieldValidationResult` entries identifying the specific field and rule violation.
3. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` (or `GetCompleteDocumentationOverviews` after finishing) with `DMPLabelingValue = "HERZINSUFFIZIENZ"` and verify the stored field values match the submitted data.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains the correctly encoded field values in the Herzinsuffizienz XML structure.
5. **Negative Test**: Submit a documentation overview with out-of-range or missing mandatory field values and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors for each invalid field.

## US-HI-6.1.9-01 — When a doctor documents eDMP HI treatment plan, Dokumentationsintervall must be specified

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.9-01 |
| **Traced from** | [HI-6.1.9-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.9-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to specify the Dokumentationsintervall in the HI treatment plan section, so that the next documentation frequency is recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Behandlungsplanung section is displayed, then a Dokumentationsintervall field is available
2. Given an interval is selected, when the XML is generated, then the Dokumentationsintervall value is encoded correctly

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Herzinsuffizienz Behandlungsplanung (treatment planning) fields including multi-select options in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates treatment planning field values against the Herzinsuffizienz plausibility rules; invalid combinations produce `FieldValidationResult` errors.
3. **Multi-Select Encoding**: For multi-select fields (e.g., Informationsangebote), the `CheckPlausibility` endpoint validates that selected values are from the permitted value set and the XML encoding correctly represents multiple selections.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` encodes the treatment planning field values correctly in the Herzinsuffizienz Behandlungsplanung XML section.
5. **Negative Test**: Submit a documentation overview with invalid multi-select combinations and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors.

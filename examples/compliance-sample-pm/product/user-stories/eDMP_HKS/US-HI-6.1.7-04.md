## US-HI-6.1.7-04 — When a doctor documents eDMP HI medication, Mineralokortikoidrezeptorantagonisten status must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.7-04 |
| **Traced from** | [HI-6.1.7-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.7-04.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Mineralokortikoidrezeptorantagonisten medication status in the HI medication section, so that MRA therapy is recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the medication section is displayed, then a Mineralokortikoidrezeptorantagonisten field is available
2. Given a selection is made, when the XML is generated, then the Mineralokortikoidrezeptorantagonisten value is encoded correctly

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Herzinsuffizienz therapy/medication fields submitted in the `DocumentationOverview.fields` array with the correct medication field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates medication field values against the Herzinsuffizienz permitted value set (e.g., Bei Bedarf, Dauermedikation, Keine, Kontraindikation); invalid selections produce `FieldValidationResult` errors.
3. **Mandatory Selection**: The `CheckPlausibility` endpoint enforces that exactly one option is selected for single-choice medication fields; missing selections produce mandatory field errors.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains correctly encoded medication field values in the Herzinsuffizienz Medikamente XML section.
5. **Negative Test**: Submit a documentation overview with no medication selection for a mandatory field and confirm `CheckPlausibility` returns a specific `FieldValidationResult` error.

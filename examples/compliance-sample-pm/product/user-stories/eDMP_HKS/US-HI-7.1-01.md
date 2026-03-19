## US-HI-7.1-01 — When a doctor documents eDMP HI follow-up, ungeplante Akutbehandlung wegen HI (Anzahl) must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-7.1-01 |
| **Traced from** | [HI-7.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-7.1-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the number of unplanned acute treatments due to Herzinsuffizienz (ungeplante Akutbehandlung wegen HI), so that acute events are tracked per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Verlauf section is displayed, then a field for ungeplante Akutbehandlung wegen HI (Anzahl) is available
2. Given a count is entered, when the XML is generated, then the Anzahl value is encoded correctly
3. Given a non-numeric or negative value is entered, when validation is triggered, then an error is displayed

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Herzinsuffizienz Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the Herzinsuffizienz follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "HERZINSUFFIZIENZ"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

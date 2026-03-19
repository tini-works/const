## US-DM2-6.1.9-05 — Practice doctor must document Diabetesbezogene stationaere Einweisung as Ja, Nein, or Veranlasst

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.9-05 |
| **Traced from** | [DM2-6.1.9-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.9-05.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Diabetesbezogene stationaere Einweisung as Ja, Nein, or Veranlasst in the Behandlungsplanung section, so that diabetes-related hospital admission referral status is documented.

### Acceptance Criteria

1. Given an eDMP DM2 Behandlungsplanung is documented, when stationaere Einweisung is recorded, then exactly one of Ja, Nein, or Veranlasst is selected
2. Given no value is selected, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 2 Behandlungsplanung (treatment planning) fields including multi-select options in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates treatment planning field values against the Diabetes mellitus Typ 2 plausibility rules; invalid combinations produce `FieldValidationResult` errors.
3. **Multi-Select Encoding**: For multi-select fields (e.g., Informationsangebote), the `CheckPlausibility` endpoint validates that selected values are from the permitted value set and the XML encoding correctly represents multiple selections.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` encodes the treatment planning field values correctly in the Diabetes mellitus Typ 2 Behandlungsplanung XML section.
5. **Negative Test**: Submit a documentation overview with invalid multi-select combinations and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors.

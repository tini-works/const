## US-DM1-6.1.9-04 — Practice doctor must document Behandlung Diabetisches Fusssyndrom as Ja, Nein, or Veranlasst

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.9-04 |
| **Traced from** | [DM1-6.1.9-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.9-04.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Behandlung Diabetisches Fusssyndrom as Ja, Nein, or Veranlasst in the Behandlungsplanung section, so that diabetic foot syndrome treatment status is captured for care coordination.

### Acceptance Criteria

1. Given an eDMP DM1 Behandlungsplanung is documented, when Behandlung Diabetisches Fusssyndrom is recorded, then exactly one of Ja, Nein, or Veranlasst is selected
2. Given no value is selected, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 1 Behandlungsplanung (treatment planning) fields including multi-select options in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates treatment planning field values against the Diabetes mellitus Typ 1 plausibility rules; invalid combinations produce `FieldValidationResult` errors.
3. **Multi-Select Encoding**: For multi-select fields (e.g., Informationsangebote), the `CheckPlausibility` endpoint validates that selected values are from the permitted value set and the XML encoding correctly represents multiple selections.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` encodes the treatment planning field values correctly in the Diabetes mellitus Typ 1 Behandlungsplanung XML section.
5. **Negative Test**: Submit a documentation overview with invalid multi-select combinations and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors.

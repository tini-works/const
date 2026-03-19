## US-COPD-6.1.9-04 — Behandlungsplanung must capture Empfehlung Tabakverzicht (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.9-04 |
| **Traced from** | [COPD-6.1.9-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.9-04.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether tobacco abstinence was recommended (Empfehlung Tabakverzicht: Ja/Nein), so that smoking cessation counseling is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Empfehlung Tabakverzicht is presented, then Ja or Nein must be selected
2. Given the patient is documented as Raucher = Ja, when Empfehlung Tabakverzicht = Nein, then a plausibility warning may be raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists COPD Behandlungsplanung (treatment planning) fields including multi-select options in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates treatment planning field values against the COPD plausibility rules; invalid combinations produce `FieldValidationResult` errors.
3. **Multi-Select Encoding**: For multi-select fields (e.g., Informationsangebote), the `CheckPlausibility` endpoint validates that selected values are from the permitted value set and the XML encoding correctly represents multiple selections.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` encodes the treatment planning field values correctly in the COPD Behandlungsplanung XML section.
5. **Negative Test**: Submit a documentation overview with invalid multi-select combinations and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors.

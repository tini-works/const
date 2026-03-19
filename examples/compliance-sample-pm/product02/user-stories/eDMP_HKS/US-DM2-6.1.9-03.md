## US-DM2-6.1.9-03 — Practice doctor must document HbA1c-Zielwert as erreicht or noch nicht erreicht

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.9-03 |
| **Traced from** | [DM2-6.1.9-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.9-03.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the HbA1c target has been reached (erreicht) or not yet reached (noch nicht erreicht) in the Behandlungsplanung section, so that HbA1c target achievement status is tracked for therapy evaluation.

### Acceptance Criteria

1. Given an eDMP DM2 Behandlungsplanung is documented, when HbA1c-Zielwert is recorded, then exactly one of erreicht or noch nicht erreicht is selected
2. Given no value is selected, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 2 Behandlungsplanung (treatment planning) fields including multi-select options in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates treatment planning field values against the Diabetes mellitus Typ 2 plausibility rules; invalid combinations produce `FieldValidationResult` errors.
3. **Multi-Select Encoding**: For multi-select fields (e.g., Informationsangebote), the `CheckPlausibility` endpoint validates that selected values are from the permitted value set and the XML encoding correctly represents multiple selections.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` encodes the treatment planning field values correctly in the Diabetes mellitus Typ 2 Behandlungsplanung XML section.
5. **Negative Test**: Submit a documentation overview with invalid multi-select combinations and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors.

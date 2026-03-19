## US-COPD-6.1.9-03 — Behandlungsplanung must capture COPD-bezogene Ueberweisung veranlasst (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.9-03 |
| **Traced from** | [COPD-6.1.9-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.9-03.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether a COPD-related referral was initiated (COPD-bezogene Ueberweisung veranlasst: Ja/Nein), so that specialist referral decisions are tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when COPD-bezogene Ueberweisung veranlasst is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists COPD Behandlungsplanung (treatment planning) fields including multi-select options in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates treatment planning field values against the COPD plausibility rules; invalid combinations produce `FieldValidationResult` errors.
3. **Multi-Select Encoding**: For multi-select fields (e.g., Informationsangebote), the `CheckPlausibility` endpoint validates that selected values are from the permitted value set and the XML encoding correctly represents multiple selections.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` encodes the treatment planning field values correctly in the COPD Behandlungsplanung XML section.
5. **Negative Test**: Submit a documentation overview with invalid multi-select combinations and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors.

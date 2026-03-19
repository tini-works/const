## US-COPD-7.1.2-01 — Verlauf must capture An Tabakentwoehnung teilgenommen (Ja/Nein/War aktuell nicht moeglich)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-7.1.2-01 |
| **Traced from** | [COPD-7.1.2-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-7.1.2-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the patient participated in a tobacco cessation program (An Tabakentwoehnung teilgenommen: Ja/Nein/War aktuell nicht moeglich), so that smoking cessation compliance is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Verlauf section is displayed, when An Tabakentwoehnung teilgenommen is presented, then exactly one of Ja, Nein, War aktuell nicht moeglich must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists COPD Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the COPD follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "COPD"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

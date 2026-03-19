## US-COPD-7.1.1-01 — Verlauf must capture Haeufigkeit Exazerbationen seit letzter Dokumentation (Anzahl)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-7.1.1-01 |
| **Traced from** | [COPD-7.1.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-7.1.1-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the number of exacerbations since the last documentation (Haeufigkeit Exazerbationen seit letzter Dokumentation: Anzahl), so that disease progression is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Verlauf section is displayed, when Haeufigkeit Exazerbationen is entered, then a non-negative integer count is accepted
2. Given a negative or non-numeric value is entered, when saved, then a validation error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists COPD Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the COPD follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "COPD"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

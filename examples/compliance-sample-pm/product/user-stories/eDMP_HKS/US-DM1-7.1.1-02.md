## US-DM1-7.1.1-02 — Practice doctor must document Stationaere Notfallbehandlung wegen Diabetes mellitus as a count

| Field | Value |
|-------|-------|
| **ID** | US-DM1-7.1.1-02 |
| **Traced from** | [DM1-7.1.1-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-7.1.1-02.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the number of Stationaere Notfallbehandlungen wegen Diabetes mellitus in the Verlauf section, so that emergency hospital treatments are tracked for disease severity monitoring.

### Acceptance Criteria

1. Given an eDMP DM1 Verlauf section is documented, when Stationaere Notfallbehandlung is recorded, then a non-negative integer count is stored
2. Given a negative or non-numeric value is entered, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 1 Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the Diabetes mellitus Typ 1 follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "DM1"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

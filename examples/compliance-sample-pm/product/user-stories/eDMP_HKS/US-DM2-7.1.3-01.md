## US-DM2-7.1.3-01 — Practice doctor must document Ophthalmologische Netzhautuntersuchung in the Verlauf section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-7.1.3-01 |
| **Traced from** | [DM2-7.1.3-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-7.1.3-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Ophthalmologische Netzhautuntersuchung as Durchgefuehrt, Nicht durchgefuehrt, or Veranlasst in the Verlauf section, so that retinal examination status is tracked for diabetic retinopathy screening.

### Acceptance Criteria

1. Given an eDMP DM2 Verlauf section is documented, when Ophthalmologische Netzhautuntersuchung is recorded, then exactly one of Durchgefuehrt, Nicht durchgefuehrt, or Veranlasst is selected
2. Given no value is selected, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 2 Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the Diabetes mellitus Typ 2 follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "DM2"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

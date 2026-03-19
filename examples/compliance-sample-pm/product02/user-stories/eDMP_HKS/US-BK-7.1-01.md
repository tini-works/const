## US-BK-7.1-01 — Practice doctor must document follow-up specific fields in the Verlauf section

| Field | Value |
|-------|-------|
| **ID** | US-BK-7.1-01 |
| **Traced from** | [BK-7.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-7.1-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document follow-up specific fields in the Verlauf section of the eDMP Brustkrebs documentation, so that breast cancer follow-up data is captured for long-term outcome monitoring.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Verlauf section is documented, when follow-up fields are recorded, then all required follow-up data points are stored
2. Given required follow-up fields are missing, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Brustkrebs Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the Brustkrebs follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "BRUSTKREBS"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

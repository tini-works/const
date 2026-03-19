## US-DEP-7.1-01 — When a doctor documents eDMP Depression follow-up, Depression-specific Verlauf fields must be captured

| Field | Value |
|-------|-------|
| **ID** | US-DEP-7.1-01 |
| **Traced from** | [DEP-7.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-7.1-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Depression-specific follow-up fields in the Verlauf section, so that the course of treatment is recorded per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Verlauf section is displayed, then Depression-specific follow-up fields are available
2. Given follow-up data is entered, when the XML is generated, then the values are encoded in the correct Depression-specific elements

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Depression Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the Depression follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "DEPRESSION"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

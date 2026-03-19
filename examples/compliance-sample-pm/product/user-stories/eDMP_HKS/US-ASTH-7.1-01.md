## US-ASTH-7.1-01 — Verlaufsdokumentation must capture Ungeplante Akutbehandlung seit letzter Dokumentation (Anzahl)

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-7.1-01 |
| **Traced from** | [ASTH-7.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-7.1-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the number of unplanned acute treatments since the last documentation (Ungeplante Akutbehandlung seit letzter Dokumentation: Anzahl), so that exacerbation frequency is tracked per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Verlaufsdokumentation section is displayed, when Ungeplante Akutbehandlung is entered, then a non-negative integer count is accepted
2. Given a negative or non-numeric value is entered, when saved, then a validation error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Asthma Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the Asthma follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "ASTHMA"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

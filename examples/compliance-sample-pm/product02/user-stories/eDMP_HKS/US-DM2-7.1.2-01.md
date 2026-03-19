## US-DM2-7.1.2-01 — Practice doctor must document Empfohlene Schulung(en) wahrgenommen with nested Diabetes and Hypertonie sub-fields

| Field | Value |
|-------|-------|
| **ID** | US-DM2-7.1.2-01 |
| **Traced from** | [DM2-7.1.2-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-7.1.2-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether recommended Schulungen were attended, with separate sub-fields for Diabetes-Schulung and Hypertonie-Schulung each accepting Ja, Nein, War aktuell nicht moeglich, or Bei letzter Doku keine Schulung empfohlen, so that attendance of recommended education programmes is tracked for each programme type individually.

### Acceptance Criteria

1. Given an eDMP DM2 Verlauf section is documented, when Empfohlene Schulung wahrgenommen is recorded, then Diabetes-Schulung status is one of Ja, Nein, War aktuell nicht moeglich, or Bei letzter Doku keine Schulung empfohlen
2. Given an eDMP DM2 Verlauf section is documented, when Empfohlene Schulung wahrgenommen is recorded, then Hypertonie-Schulung status is one of Ja, Nein, War aktuell nicht moeglich, or Bei letzter Doku keine Schulung empfohlen
3. Given either sub-field is missing, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 2 Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the Diabetes mellitus Typ 2 follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "DM2"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

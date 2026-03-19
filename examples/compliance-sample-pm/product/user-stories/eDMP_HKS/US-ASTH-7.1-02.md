## US-ASTH-7.1-02 — Verlaufsdokumentation must capture Empfohlene Asthma-Schulung wahrgenommen

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-7.1-02 |
| **Traced from** | [ASTH-7.1-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-7.1-02.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the recommended Asthma training was attended (Empfohlene Asthma-Schulung wahrgenommen) with options Ja, Nein, War aktuell nicht moeglich, or Bei letzter Dokumentation keine Schulung empfohlen, so that training compliance is tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Verlaufsdokumentation section is displayed, when Empfohlene Schulung wahrgenommen is presented, then exactly one of Ja, Nein, War aktuell nicht moeglich, Bei letzter Dokumentation keine Schulung empfohlen must be selected
2. Given the previous documentation recommended a Schulung (Ja), when "Bei letzter Dokumentation keine Schulung empfohlen" is selected, then a plausibility warning is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Asthma Verlaufsdokumentation fields submitted in the `DocumentationOverview.fields` array for the follow-up documentation type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates Verlaufsdokumentation-specific fields against the Asthma follow-up plausibility rules; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Cross-Documentation Validation**: The `CheckPlausibility` endpoint validates consistency between current and previous documentation values (e.g., Schulung recommendations); inconsistencies produce plausibility warnings in `FieldValidationResult`.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "ASTHMA"` and verify follow-up documentation field values are correctly persisted.
5. **Negative Test**: Submit a Verlaufsdokumentation with fields contradicting the previous documentation and confirm `CheckPlausibility` returns specific plausibility warnings.

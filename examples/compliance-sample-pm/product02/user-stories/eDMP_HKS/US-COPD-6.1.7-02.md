## US-COPD-6.1.7-02 — Medikamente must capture Lang wirksame Beta-2-Sympathomimetika

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.7-02 |
| **Traced from** | [COPD-6.1.7-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.7-02.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Lang wirksame Beta-2-Sympathomimetika usage with the defined value options, so that long-acting beta-agonist therapy is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Medikamente section is displayed, when Lang wirksame Beta-2-Sympathomimetika is presented, then exactly one valid option must be chosen
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists COPD therapy/medication fields submitted in the `DocumentationOverview.fields` array with the correct medication field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates medication field values against the COPD permitted value set (e.g., Bei Bedarf, Dauermedikation, Keine, Kontraindikation); invalid selections produce `FieldValidationResult` errors.
3. **Mandatory Selection**: The `CheckPlausibility` endpoint enforces that exactly one option is selected for single-choice medication fields; missing selections produce mandatory field errors.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains correctly encoded medication field values in the COPD Medikamente XML section.
5. **Negative Test**: Submit a documentation overview with no medication selection for a mandatory field and confirm `CheckPlausibility` returns a specific `FieldValidationResult` error.

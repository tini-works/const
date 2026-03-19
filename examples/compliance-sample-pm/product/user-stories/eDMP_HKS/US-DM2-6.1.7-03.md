## US-DM2-6.1.7-03 — Practice doctor must document ACE-Hemmer status in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.7-03 |
| **Traced from** | [DM2-6.1.7-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.7-03.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document ACE-Hemmer as Nein, Ja, Kontraindikation, or ARB in the Medikamente section, so that ACE inhibitor therapy status is captured for renal and cardiovascular protection.

### Acceptance Criteria

1. Given an eDMP DM2 Medikamente section is documented, when ACE-Hemmer is recorded, then exactly one of Nein, Ja, Kontraindikation, or ARB is selected
2. Given no value is selected, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 2 therapy/medication fields submitted in the `DocumentationOverview.fields` array with the correct medication field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates medication field values against the Diabetes mellitus Typ 2 permitted value set (e.g., Bei Bedarf, Dauermedikation, Keine, Kontraindikation); invalid selections produce `FieldValidationResult` errors.
3. **Mandatory Selection**: The `CheckPlausibility` endpoint enforces that exactly one option is selected for single-choice medication fields; missing selections produce mandatory field errors.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains correctly encoded medication field values in the Diabetes mellitus Typ 2 Medikamente XML section.
5. **Negative Test**: Submit a documentation overview with no medication selection for a mandatory field and confirm `CheckPlausibility` returns a specific `FieldValidationResult` error.

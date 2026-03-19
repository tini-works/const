## US-DM1-6.1.7-04 — Practice doctor must document HMG-CoA-Reduktase-Hemmer (Statin) status in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.7-04 |
| **Traced from** | [DM1-6.1.7-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.7-04.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document HMG-CoA-Reduktase-Hemmer as Nein, Ja, or Kontraindikation in the Medikamente section, so that statin therapy status is captured for lipid management in diabetes.

### Acceptance Criteria

1. Given an eDMP DM1 Medikamente section is documented, when HMG-CoA-Reduktase-Hemmer is recorded, then exactly one of Nein, Ja, or Kontraindikation is selected
2. Given no value is selected, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 1 therapy/medication fields submitted in the `DocumentationOverview.fields` array with the correct medication field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates medication field values against the Diabetes mellitus Typ 1 permitted value set (e.g., Bei Bedarf, Dauermedikation, Keine, Kontraindikation); invalid selections produce `FieldValidationResult` errors.
3. **Mandatory Selection**: The `CheckPlausibility` endpoint enforces that exactly one option is selected for single-choice medication fields; missing selections produce mandatory field errors.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains correctly encoded medication field values in the Diabetes mellitus Typ 1 Medikamente XML section.
5. **Negative Test**: Submit a documentation overview with no medication selection for a mandatory field and confirm `CheckPlausibility` returns a specific `FieldValidationResult` error.

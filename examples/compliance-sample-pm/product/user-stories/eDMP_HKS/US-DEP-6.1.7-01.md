## US-DEP-6.1.7-01 — When a doctor documents eDMP Depression medication, Antidepressiva fields must be captured

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.7-01 |
| **Traced from** | [DEP-6.1.7-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.7-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Depression-specific medication fields including Antidepressiva, so that the medication section reflects the required Depression pharmacotherapy data.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the medication section is displayed, then Antidepressiva-specific fields are available
2. Given Antidepressiva data is entered, when the XML is generated, then the medication values are encoded in the correct Depression-specific elements

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Depression therapy/medication fields submitted in the `DocumentationOverview.fields` array with the correct medication field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates medication field values against the Depression permitted value set (e.g., Bei Bedarf, Dauermedikation, Keine, Kontraindikation); invalid selections produce `FieldValidationResult` errors.
3. **Mandatory Selection**: The `CheckPlausibility` endpoint enforces that exactly one option is selected for single-choice medication fields; missing selections produce mandatory field errors.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains correctly encoded medication field values in the Depression Medikamente XML section.
5. **Negative Test**: Submit a documentation overview with no medication selection for a mandatory field and confirm `CheckPlausibility` returns a specific `FieldValidationResult` error.

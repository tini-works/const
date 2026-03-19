## US-KHK-6.1.7-04 — When a doctor documents eDMP KHK medication, HMG-CoA-Reduktase-Hemmer status must be captured

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.7-04 |
| **Traced from** | [KHK-6.1.7-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.7-04.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document HMG-CoA-Reduktase-Hemmer (Statin) medication status (Nein/Ja/Kontraindikation) in the KHK medication section, so that statin therapy is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the medication section is displayed, then an HMG-CoA-Reduktase-Hemmer field with options Nein, Ja, and Kontraindikation is available
2. Given a selection is made, when the XML is generated, then the HMG-CoA-Reduktase-Hemmer value is encoded correctly

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists KHK therapy/medication fields submitted in the `DocumentationOverview.fields` array with the correct medication field identifiers.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates medication field values against the KHK permitted value set (e.g., Bei Bedarf, Dauermedikation, Keine, Kontraindikation); invalid selections produce `FieldValidationResult` errors.
3. **Mandatory Selection**: The `CheckPlausibility` endpoint enforces that exactly one option is selected for single-choice medication fields; missing selections produce mandatory field errors.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` contains correctly encoded medication field values in the KHK Medikamente XML section.
5. **Negative Test**: Submit a documentation overview with no medication selection for a mandatory field and confirm `CheckPlausibility` returns a specific `FieldValidationResult` error.

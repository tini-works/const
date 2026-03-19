## US-DEP-6.1.9-02 — When a doctor documents eDMP Depression treatment plan, Informationsangebote must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.9-02 |
| **Traced from** | [DEP-6.1.9-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.9-02.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Informationsangebote in the treatment plan section, so that patient information offerings are recorded per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Behandlungsplanung section is displayed, then an Informationsangebote field is available
2. Given information offerings are documented, when the XML is generated, then the values are encoded correctly

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Depression Behandlungsplanung (treatment planning) fields including multi-select options in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates treatment planning field values against the Depression plausibility rules; invalid combinations produce `FieldValidationResult` errors.
3. **Multi-Select Encoding**: For multi-select fields (e.g., Informationsangebote), the `CheckPlausibility` endpoint validates that selected values are from the permitted value set and the XML encoding correctly represents multiple selections.
4. **XML Encoding**: Call `EDMPApp.FinishDocumentationOverview` and verify the returned `CheckPlausibilityResponse.billingFile` encodes the treatment planning field values correctly in the Depression Behandlungsplanung XML section.
5. **Negative Test**: Submit a documentation overview with invalid multi-select combinations and confirm `CheckPlausibility` returns specific `FieldValidationResult` errors.

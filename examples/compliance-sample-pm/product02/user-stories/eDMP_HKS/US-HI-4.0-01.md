## US-HI-4.0-01 — When practice software generates eDMP HI XML, it must use CDA levelone document structure

| Field | Value |
|-------|-------|
| **ID** | US-HI-4.0-01 |
| **Traced from** | [HI-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-4.0-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate eDMP Herzinsuffizienz documentation using CDA levelone document structure, so that the XML output conforms to the required clinical document architecture.

### Acceptance Criteria

1. Given an eDMP HI documentation is exported, when the XML is generated, then the root element conforms to CDA levelone structure
2. Given a generated XML, when validated against the CDA levelone schema, then no schema violations are reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint produces eDMP Herzinsuffizienz XML documents following the CDA levelone structure (clinical_document_header + body) when `DMPLabelingValue = "HERZINSUFFIZIENZ"` is provided.
2. **Schema Validation**: The `EDMPApp.CheckPlausibility` endpoint (NATS topic `api.app.app_core.EDMPApp.CheckPlausibility`) validates the generated XML against the CDA schema; structural errors produce `FieldValidationResult` entries with `isPlausible = false`.
3. **Billing File Generation**: Call `EDMPApp.FinishDocumentationOverview` and verify the `CheckPlausibilityResponse.billingFile` contains a structurally valid CDA document with clinical_document_header and body.
4. **Negative Test**: Submit a documentation overview with missing clinical_document_header or body and confirm `CheckPlausibility` returns specific structural validation errors.

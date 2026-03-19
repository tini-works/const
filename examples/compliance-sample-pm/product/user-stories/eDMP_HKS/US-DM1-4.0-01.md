## US-DM1-4.0-01 — Practice software must produce eDMP DM1 documents as valid CDA levelone XML

| Field | Value |
|-------|-------|
| **ID** | US-DM1-4.0-01 |
| **Traced from** | [DM1-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-4.0-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to produce eDMP Diabetes mellitus Typ 1 documentation as valid CDA levelone XML documents, so that the documents conform to the HL7 CDA standard and can be processed by receiving systems.

### Acceptance Criteria

1. Given an eDMP DM1 documentation is created, when the XML is generated, then it is a valid CDA levelone document
2. Given a document missing required CDA levelone elements, when validated, then a schema error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint produces eDMP Diabetes mellitus Typ 1 XML documents following the CDA levelone structure (clinical_document_header + body) when `DMPLabelingValue = "DM1"` is provided.
2. **Schema Validation**: The `EDMPApp.CheckPlausibility` endpoint (NATS topic `api.app.app_core.EDMPApp.CheckPlausibility`) validates the generated XML against the CDA schema; structural errors produce `FieldValidationResult` entries with `isPlausible = false`.
3. **Billing File Generation**: Call `EDMPApp.FinishDocumentationOverview` and verify the `CheckPlausibilityResponse.billingFile` contains a structurally valid CDA document with clinical_document_header and body.
4. **Negative Test**: Submit a documentation overview with missing clinical_document_header or body and confirm `CheckPlausibility` returns specific structural validation errors.

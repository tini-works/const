## US-HKS-4.0-01 — Practice software must produce eHKS documents as valid CDA levelone XML

| Field | Value |
|-------|-------|
| **ID** | US-HKS-4.0-01 |
| **Traced from** | [HKS-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-4.0-01.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to produce eHKS documentation as valid CDA levelone XML documents, so that the documents conform to the HL7 CDA standard and can be processed by receiving systems.

### Acceptance Criteria

1. Given an eHKS documentation is created, when the XML is generated, then it is a valid CDA levelone document
2. Given a document missing required CDA levelone elements, when validated, then a schema error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint produces eHKS XML documents following the KBV eHKS schema structure when `DMPLabelingValue = "HKS"` is provided.
2. **Schema Validation**: The `EDMPApp.CheckPlausibility` endpoint (NATS topic `api.app.app_core.EDMPApp.CheckPlausibility`) validates the generated XML against the eHKS schema; structural errors in the XML body produce `FieldValidationResult` entries with `isPlausible = false`.
3. **Billing File Generation**: Call `EDMPApp.FinishDocumentationOverview` and verify the `CheckPlausibilityResponse.billingFile` contains a structurally valid eHKS XML document.
4. **Negative Test**: Submit a documentation overview with missing required eHKS header elements and confirm `CheckPlausibility` returns specific structural validation errors.

## US-COPD-6.1.3-01 — Practice software must encode clinical data using sciphox:sciphox-ssu observation structure

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.3-01 |
| **Traced from** | [COPD-6.1.3-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.3-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to encode all clinical data fields using the sciphox:sciphox-ssu observation structure, so that data values are machine-readable and conform to the eDMP COPD XML schema.

### Acceptance Criteria

1. Given clinical data is documented for eDMP COPD, when the XML is generated, then each data field is wrapped in a sciphox:sciphox-ssu observation element
2. Given the observation structure is missing or malformed, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint encodes all COPD clinical data fields using the sciphox:sciphox-ssu observation structure when generating the XML document.
2. **Field Validation**: The `EDMPApp.CheckPlausibility` endpoint (NATS topic `api.app.app_core.EDMPApp.CheckPlausibility`) validates that each data field is wrapped in a sciphox:sciphox-ssu observation element; missing or malformed observation structures produce `FieldValidationResult` errors with `isPlausible = false`.
3. **Save and Retrieve**: Call `EDMPApp.SaveDocumentationOverview` to persist the documentation, then `EDMPApp.GetCompleteDocumentationOverviews` to verify the stored fields match the sciphox-ssu structure.
4. **Negative Test**: Submit a documentation overview with missing observation wrappers and confirm `CheckPlausibility` returns specific structural errors.

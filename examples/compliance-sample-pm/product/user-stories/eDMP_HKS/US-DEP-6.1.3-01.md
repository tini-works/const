## US-DEP-6.1.3-01 — When practice software encodes eDMP Depression observations, Sciphox-SSU encoding must be used

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.3-01 |
| **Traced from** | [DEP-6.1.3-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.3-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to encode eDMP Depression observation data using Sciphox-SSU observation encoding, so that clinical values are structured in the standardized Sciphox format.

### Acceptance Criteria

1. Given clinical observation data for Depression, when encoded in the XML, then Sciphox-SSU element structure is used
2. Given an observation element, when validated, then it conforms to the Sciphox-SSU schema for the observation type

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint encodes all Depression clinical data fields using the sciphox:sciphox-ssu observation structure when generating the XML document.
2. **Field Validation**: The `EDMPApp.CheckPlausibility` endpoint (NATS topic `api.app.app_core.EDMPApp.CheckPlausibility`) validates that each data field is wrapped in a sciphox:sciphox-ssu observation element; missing or malformed observation structures produce `FieldValidationResult` errors with `isPlausible = false`.
3. **Save and Retrieve**: Call `EDMPApp.SaveDocumentationOverview` to persist the documentation, then `EDMPApp.GetCompleteDocumentationOverviews` to verify the stored fields match the sciphox-ssu structure.
4. **Negative Test**: Submit a documentation overview with missing observation wrappers and confirm `CheckPlausibility` returns specific structural errors.

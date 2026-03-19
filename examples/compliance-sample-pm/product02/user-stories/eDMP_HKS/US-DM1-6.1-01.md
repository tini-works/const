## US-DM1-6.1-01 — Practice software must structure eDMP DM1 documents with section/paragraph elements using DM1 caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1-01 |
| **Traced from** | [DM1-6.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to structure eDMP DM1 documents using the prescribed section and paragraph elements with DM1-specific caption_cd DN values, so that the document sections are machine-readable and match the KBV section catalogue.

### Acceptance Criteria

1. Given an eDMP DM1 document is generated, when sections are written, then each section/paragraph uses the correct DM1 caption_cd DN value
2. Given an unknown or missing caption_cd DN value, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint (NATS topic `api.app.app_core.EDMPApp.CreateDocument`) structures the Diabetes mellitus Typ 1 XML body with section/paragraph/caption/content elements where caption_cd DN values match the Diabetes mellitus Typ 1 plausibility catalog.
2. **Section Structure Validation**: The `EDMPApp.CheckPlausibility` endpoint validates the overall body structure including section ordering and caption_cd DN values; incorrect values produce `FieldValidationResult` errors.
3. **Complete Documentation Flow**: Call `EDMPApp.SaveDocumentationOverview` to persist, then `EDMPApp.FinishDocumentationOverview` to finalize, and verify the `CheckPlausibilityResponse` confirms all Diabetes mellitus Typ 1-specific caption_cd DN values are correct.
4. **GetDMPDocument Verification**: Call `EDMPApp.GetDMPDocument` with `DMPLabelingValues = ["DM1"]` and verify the returned document contains the correct body structure.

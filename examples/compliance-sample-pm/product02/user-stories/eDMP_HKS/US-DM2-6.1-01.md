## US-DM2-6.1-01 — Practice software must structure eDMP DM2 documents with section/paragraph elements using DM2 caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1-01 |
| **Traced from** | [DM2-6.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to structure eDMP DM2 documents using the prescribed section and paragraph elements with DM2-specific caption_cd DN values, so that the document sections are machine-readable and match the KBV section catalogue.

### Acceptance Criteria

1. Given an eDMP DM2 document is generated, when sections are written, then each section/paragraph uses the correct DM2 caption_cd DN value
2. Given an unknown or missing caption_cd DN value, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint (NATS topic `api.app.app_core.EDMPApp.CreateDocument`) structures the Diabetes mellitus Typ 2 XML body with section/paragraph/caption/content elements where caption_cd DN values match the Diabetes mellitus Typ 2 plausibility catalog.
2. **Section Structure Validation**: The `EDMPApp.CheckPlausibility` endpoint validates the overall body structure including section ordering and caption_cd DN values; incorrect values produce `FieldValidationResult` errors.
3. **Complete Documentation Flow**: Call `EDMPApp.SaveDocumentationOverview` to persist, then `EDMPApp.FinishDocumentationOverview` to finalize, and verify the `CheckPlausibilityResponse` confirms all Diabetes mellitus Typ 2-specific caption_cd DN values are correct.
4. **GetDMPDocument Verification**: Call `EDMPApp.GetDMPDocument` with `DMPLabelingValues = ["DM2"]` and verify the returned document contains the correct body structure.

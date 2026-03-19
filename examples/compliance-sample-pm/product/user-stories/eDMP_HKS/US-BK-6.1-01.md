## US-BK-6.1-01 — Practice software must structure eDMP Brustkrebs documents with correct section/paragraph elements

| Field | Value |
|-------|-------|
| **ID** | US-BK-6.1-01 |
| **Traced from** | [BK-6.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-6.1-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to structure eDMP Brustkrebs documents using the prescribed section and paragraph elements, so that the document sections are machine-readable and match the KBV section catalogue.

### Acceptance Criteria

1. Given an eDMP Brustkrebs document is generated, when sections are written, then each section/paragraph uses the correct caption_cd DN value
2. Given an unknown or missing caption_cd DN value, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint (NATS topic `api.app.app_core.EDMPApp.CreateDocument`) structures the Brustkrebs XML body with section/paragraph/caption/content elements where caption_cd DN values match the Brustkrebs plausibility catalog.
2. **Section Structure Validation**: The `EDMPApp.CheckPlausibility` endpoint validates the overall body structure including section ordering and caption_cd DN values; incorrect values produce `FieldValidationResult` errors.
3. **Complete Documentation Flow**: Call `EDMPApp.SaveDocumentationOverview` to persist, then `EDMPApp.FinishDocumentationOverview` to finalize, and verify the `CheckPlausibilityResponse` confirms all Brustkrebs-specific caption_cd DN values are correct.
4. **GetDMPDocument Verification**: Call `EDMPApp.GetDMPDocument` with `DMPLabelingValues = ["BRUSTKREBS"]` and verify the returned document contains the correct body structure.

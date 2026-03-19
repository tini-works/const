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

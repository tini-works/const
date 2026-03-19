## BK-6.1-01 — Practice software must structure eDMP Brustkrebs documents with correct section/paragraph elements

| Field | Value |
|-------|-------|
| **ID** | BK-6.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 6.1 -- Koerperstruktur |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-BK-6.1-01](../../../../../user-stories/eDMP_HKS/US-BK-6.1-01.md) |

### Requirement

As a practice software, I want to structure eDMP Brustkrebs documents using the prescribed section and paragraph elements, so that the document sections are machine-readable and match the KBV section catalogue.

### Acceptance Criteria

1. Given an eDMP Brustkrebs document is generated, when sections are written, then each section/paragraph uses the correct caption_cd DN value
2. Given an unknown or missing caption_cd DN value, when validated, then an error is reported

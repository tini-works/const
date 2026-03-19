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

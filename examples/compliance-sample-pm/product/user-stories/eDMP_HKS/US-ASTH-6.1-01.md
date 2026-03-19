## US-ASTH-6.1-01 — Practice software must structure body with section/paragraph/caption/content using Asthma caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1-01 |
| **Traced from** | [ASTH-6.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to structure the XML body with section, paragraph, caption, and content elements where caption_cd DN values match the Asthma plausibility catalog, so that clinical data sections are correctly identified for validation.

### Acceptance Criteria

1. Given an eDMP Asthma document body is generated, when sections are created, then each contains paragraph/caption/content elements
2. Given caption_cd DN values are assigned, when compared to the plausibility catalog, then all values match the expected Asthma-specific entries

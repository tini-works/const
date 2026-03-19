## US-BK-6.1.5-01 — Practice doctor must document Tumor staging data in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-BK-6.1.5-01 |
| **Traced from** | [BK-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-6.1.5-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Tumor staging data in the Anamnese section of the eDMP Brustkrebs documentation, so that tumour classification data is captured for breast cancer staging and treatment planning.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Anamnese is documented, when Tumor staging is recorded, then the required staging fields (TNM classification) are filled
2. Given staging data is incomplete, when validated, then an error is reported

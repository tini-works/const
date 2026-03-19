## BK-6.1.5-01 — Practice doctor must document Tumor staging data in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | BK-6.1.5-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 6.1.5 -- Anamnese (Tumorstaging) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-BK-6.1.5-01](../../../../../user-stories/eDMP_HKS/US-BK-6.1.5-01.md) |

### Requirement

As a practice doctor, I want to document Tumor staging data in the Anamnese section of the eDMP Brustkrebs documentation, so that tumour classification data is captured for breast cancer staging and treatment planning.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Anamnese is documented, when Tumor staging is recorded, then the required staging fields (TNM classification) are filled
2. Given staging data is incomplete, when validated, then an error is reported

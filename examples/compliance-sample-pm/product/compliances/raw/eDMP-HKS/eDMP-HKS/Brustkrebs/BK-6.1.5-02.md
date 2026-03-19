## BK-6.1.5-02 — Practice doctor must document Receptor status (Oestrogenrezeptor, Progesteronrezeptor, HER2) in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | BK-6.1.5-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 6.1.5 -- Anamnese (Rezeptorstatus) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-BK-6.1.5-02](../../../../../user-stories/eDMP_HKS/US-BK-6.1.5-02.md) |

### Requirement

As a practice doctor, I want to document Receptor status including Oestrogenrezeptor, Progesteronrezeptor, and HER2 in the Anamnese section, so that hormone and HER2 receptor status is captured for therapy selection guidance.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Anamnese is documented, when Receptor status is recorded, then Oestrogenrezeptor, Progesteronrezeptor, and HER2 status are each documented
2. Given any receptor status field is missing, when validated, then an error is reported

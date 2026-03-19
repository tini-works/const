## BK-6.1.4-01 — Practice doctor must record Einschreibung reason selecting from Primaertumor, Kontralateraler Brustkrebs, Lokoregionaeres Rezidiv, or Fernmetastasen

| Field | Value |
|-------|-------|
| **ID** | BK-6.1.4-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 6.1.4 -- Administrative Daten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-BK-6.1.4-01](../../../../user-stories/eDMP_HKS/US-BK-6.1.4-01.md) |

### Requirement

As a practice doctor, I want to record the enrollment reason selecting from Primaertumor, Kontralateraler Brustkrebs, Lokoregionaeres Rezidiv, or Fernmetastasen in the administrative section, so that the specific breast cancer enrollment context is transmitted for correct programme assignment.

### Acceptance Criteria

1. Given a new eDMP Brustkrebs documentation is created, when the administrative section is filled, then exactly one of Primaertumor, Kontralateraler Brustkrebs, Lokoregionaeres Rezidiv, or Fernmetastasen is selected as Einschreibung reason
2. Given no Einschreibung reason is selected, when validated, then an error is raised

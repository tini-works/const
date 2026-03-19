## ASTH-6.1.7-04 — Medikamente must capture Systemische Glukokortikosteroide (Bei Bedarf/Dauermedikation/Keine/Kontraindikation)

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.7-04 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.7 — Medikamente |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.7-04](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.7-04.md) |

### Requirement

As a practice doctor, I want to document Systemische Glukokortikosteroide usage with options Bei Bedarf, Dauermedikation, Keine, or Kontraindikation, so that systemic corticosteroid therapy is tracked per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Medikamente section is displayed, when Systemische Glukokortikosteroide is selected, then exactly one of Bei Bedarf, Dauermedikation, Keine, Kontraindikation must be chosen
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

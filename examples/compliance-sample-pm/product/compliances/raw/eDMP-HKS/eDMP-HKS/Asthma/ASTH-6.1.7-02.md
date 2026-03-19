## ASTH-6.1.7-02 — Medikamente must capture Inhalative lang wirksame Beta-2-Sympathomimetika (Bei Bedarf/Dauermedikation/Keine/Kontraindikation)

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.7-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.7 — Medikamente |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.7-02](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.7-02.md) |

### Requirement

As a practice doctor, I want to document Inhalative lang wirksame Beta-2-Sympathomimetika usage with options Bei Bedarf, Dauermedikation, Keine, or Kontraindikation, so that long-acting beta-agonist therapy is tracked per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Medikamente section is displayed, when Inhalative lang wirksame Beta-2-Sympathomimetika is selected, then exactly one of Bei Bedarf, Dauermedikation, Keine, Kontraindikation must be chosen
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

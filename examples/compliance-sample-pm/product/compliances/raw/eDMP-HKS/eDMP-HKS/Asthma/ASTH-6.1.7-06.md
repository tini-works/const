## ASTH-6.1.7-06 — Medikamente must capture Inhalationstechnik ueberprueft (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.7-06 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.7 — Medikamente |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.7-06](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.7-06.md) |

### Requirement

As a practice doctor, I want to document whether inhalation technique was checked (Inhalationstechnik ueberprueft: Ja/Nein), so that patient education on inhaler use is tracked per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Medikamente section is displayed, when Inhalationstechnik ueberprueft is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

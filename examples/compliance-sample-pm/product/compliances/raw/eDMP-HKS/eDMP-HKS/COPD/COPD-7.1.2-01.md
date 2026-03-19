## COPD-7.1.2-01 — Verlauf must capture An Tabakentwoehnung teilgenommen (Ja/Nein/War aktuell nicht moeglich)

| Field | Value |
|-------|-------|
| **ID** | COPD-7.1.2-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 7.1.2 — Verlaufsdokumentation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-7.1.2-01](../../../../user-stories/eDMP_HKS/US-COPD-7.1.2-01.md) |

### Requirement

As a practice doctor, I want to document whether the patient participated in a tobacco cessation program (An Tabakentwoehnung teilgenommen: Ja/Nein/War aktuell nicht moeglich), so that smoking cessation compliance is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Verlauf section is displayed, when An Tabakentwoehnung teilgenommen is presented, then exactly one of Ja, Nein, War aktuell nicht moeglich must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

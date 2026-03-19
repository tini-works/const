## US-COPD-7.1.2-01 — Verlauf must capture An Tabakentwoehnung teilgenommen (Ja/Nein/War aktuell nicht moeglich)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-7.1.2-01 |
| **Traced from** | [COPD-7.1.2-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-7.1.2-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the patient participated in a tobacco cessation program (An Tabakentwoehnung teilgenommen: Ja/Nein/War aktuell nicht moeglich), so that smoking cessation compliance is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Verlauf section is displayed, when An Tabakentwoehnung teilgenommen is presented, then exactly one of Ja, Nein, War aktuell nicht moeglich must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

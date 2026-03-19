## COPD-7.1.2-02 — Verlauf must capture Empfohlene Schulung wahrgenommen

| Field | Value |
|-------|-------|
| **ID** | COPD-7.1.2-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 7.1.2 — Verlaufsdokumentation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-7.1.2-02](../../../../user-stories/eDMP_HKS/US-COPD-7.1.2-02.md) |

### Requirement

As a practice doctor, I want to document whether the recommended COPD training was attended (Empfohlene Schulung wahrgenommen) with options Ja, Nein, War aktuell nicht moeglich, or Bei letzter Dokumentation keine Schulung empfohlen, so that training compliance is tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Verlauf section is displayed, when Empfohlene Schulung wahrgenommen is presented, then exactly one of Ja, Nein, War aktuell nicht moeglich, Bei letzter Dokumentation keine Schulung empfohlen must be selected
2. Given the previous documentation recommended a Schulung (Ja), when "Bei letzter Dokumentation keine Schulung empfohlen" is selected, then a plausibility warning is raised

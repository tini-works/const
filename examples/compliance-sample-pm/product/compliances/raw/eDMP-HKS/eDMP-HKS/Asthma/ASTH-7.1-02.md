## ASTH-7.1-02 — Verlaufsdokumentation must capture Empfohlene Asthma-Schulung wahrgenommen

| Field | Value |
|-------|-------|
| **ID** | ASTH-7.1-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 7 — Verlaufsdokumentation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-7.1-02](../../../../user-stories/eDMP_HKS/US-ASTH-7.1-02.md) |

### Requirement

As a practice doctor, I want to document whether the recommended Asthma training was attended (Empfohlene Asthma-Schulung wahrgenommen) with options Ja, Nein, War aktuell nicht moeglich, or Bei letzter Dokumentation keine Schulung empfohlen, so that training compliance is tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Verlaufsdokumentation section is displayed, when Empfohlene Schulung wahrgenommen is presented, then exactly one of Ja, Nein, War aktuell nicht moeglich, Bei letzter Dokumentation keine Schulung empfohlen must be selected
2. Given the previous documentation recommended a Schulung (Ja), when "Bei letzter Dokumentation keine Schulung empfohlen" is selected, then a plausibility warning is raised

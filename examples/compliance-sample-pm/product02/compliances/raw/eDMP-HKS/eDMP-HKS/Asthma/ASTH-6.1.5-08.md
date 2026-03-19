## ASTH-6.1.5-08 — Anamnese must capture Aktueller FEV1-Wert (%) measured at least every 12 months

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.5-08 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.5-08](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.5-08.md) |

### Requirement

As a practice doctor, I want to document the current FEV1 value (Aktueller FEV1-Wert) as a percentage, measured at least every 12 months, so that lung function is monitored per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when FEV1-Wert is entered, then the field accepts a percentage value
2. Given more than 12 months have elapsed since the last FEV1 measurement, when the form is opened, then a reminder is displayed to perform a new measurement
3. Given the FEV1 value is outside plausible range (0-150%), when saved, then a validation warning is displayed

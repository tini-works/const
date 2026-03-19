## COPD-6.1.5-03 — Anamnese must capture Aktueller FEV1-Wert (%)

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.5-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.5-03](../../../../user-stories/eDMP_HKS/US-COPD-6.1.5-03.md) |

### Requirement

As a practice doctor, I want to document the current FEV1 value (Aktueller FEV1-Wert) as a percentage in the Anamnese section, so that lung function is monitored per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Anamnese form is displayed, when FEV1-Wert is entered, then the field accepts a percentage value
2. Given the FEV1 value is outside plausible range (0-150%), when saved, then a validation warning is displayed

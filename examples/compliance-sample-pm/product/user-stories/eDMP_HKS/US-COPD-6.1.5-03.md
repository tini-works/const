## US-COPD-6.1.5-03 — Anamnese must capture Aktueller FEV1-Wert (%)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.5-03 |
| **Traced from** | [COPD-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.5-03.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the current FEV1 value (Aktueller FEV1-Wert) as a percentage in the Anamnese section, so that lung function is monitored per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Anamnese form is displayed, when FEV1-Wert is entered, then the field accepts a percentage value
2. Given the FEV1 value is outside plausible range (0-150%), when saved, then a validation warning is displayed

## ASTH-6.1.5-07 — Anamnese must capture Asthmabedingte Stoerung Nachtschlaf in last 4 weeks

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.5-07 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.5-07](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.5-07.md) |

### Requirement

As a practice doctor, I want to document asthma-related sleep disturbance (Asthmabedingte Stoerung Nachtschlaf) over the last 4 weeks, so that nocturnal symptom burden is recorded for treatment planning.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when sleep disturbance is entered, then the field captures nocturnal symptoms over the last 4 weeks
2. Given the field is left empty, when the form is submitted, then a mandatory field error is raised

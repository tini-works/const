## ASTH-6.1.5-04 — Anamnese must capture Haeufigkeit Asthma-Symptome tagsueber in last 4 weeks

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.5-04 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.5-04](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.5-04.md) |

### Requirement

As a practice doctor, I want to document the frequency of daytime asthma symptoms (Haeufigkeit Asthma-Symptome tagsueber) over the last 4 weeks, so that symptom burden is recorded for treatment assessment.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when symptom frequency is entered, then the field captures daytime symptoms over the last 4 weeks
2. Given the field is left empty, when the form is submitted, then a mandatory field error is raised

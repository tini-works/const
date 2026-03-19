## US-ASTH-6.1.5-05 — Anamnese must capture Haeufigkeit Bedarfsmedikation in last 4 weeks

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.5-05 |
| **Traced from** | [ASTH-6.1.5-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.5-05.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the frequency of rescue medication use (Haeufigkeit Bedarfsmedikation) over the last 4 weeks, so that the patient's need for acute relief is tracked per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when Bedarfsmedikation frequency is entered, then the field captures usage over the last 4 weeks
2. Given the field is left empty, when the form is submitted, then a mandatory field error is raised

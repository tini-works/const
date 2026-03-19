## ASTH-6.1.5-06 — Anamnese must capture Einschraenkung Aktivitaeten im Alltag in last 4 weeks

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.5-06 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.5-06](../../../../../user-stories/eDMP_HKS/US-ASTH-6.1.5-06.md) |

### Requirement

As a practice doctor, I want to document the restriction of daily activities (Einschraenkung Aktivitaeten im Alltag) over the last 4 weeks, so that the impact of asthma on the patient's daily life is assessed.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when activity restriction is entered, then the field captures limitations over the last 4 weeks
2. Given the field is left empty, when the form is submitted, then a mandatory field error is raised

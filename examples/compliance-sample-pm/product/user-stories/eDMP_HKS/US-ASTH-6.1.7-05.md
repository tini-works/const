## US-ASTH-6.1.7-05 — Medikamente must capture Sonstige asthmaspezifische Medikation (Nein/Leukotrienrezeptorantagonist/Andere)

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.7-05 |
| **Traced from** | [ASTH-6.1.7-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.7-05.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Sonstige asthmaspezifische Medikation with options Nein, Leukotrienrezeptorantagonist, or Andere, so that additional asthma-specific medications are tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Medikamente section is displayed, when Sonstige asthmaspezifische Medikation is selected, then one or more of Nein, Leukotrienrezeptorantagonist, Andere can be chosen
2. Given "Nein" is selected together with another option, when saved, then a validation error is raised

## US-COPD-6.1.7-05 — Medikamente must capture Sonstige diagnosespezifische Medikation (Nein/Theophyllin/Inhalative GKS/Systemische GKS/Andere)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.7-05 |
| **Traced from** | [COPD-6.1.7-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.7-05.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Sonstige diagnosespezifische Medikation with options Nein, Theophyllin, Inhalative GKS, Systemische GKS, or Andere, so that additional COPD-specific medications are tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Medikamente section is displayed, when Sonstige diagnosespezifische Medikation is presented, then one or more of Nein, Theophyllin, Inhalative GKS, Systemische GKS, Andere can be chosen
2. Given "Nein" is selected together with another option, when saved, then a validation error is raised

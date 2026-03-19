## COPD-6.1.7-05 — Medikamente must capture Sonstige diagnosespezifische Medikation (Nein/Theophyllin/Inhalative GKS/Systemische GKS/Andere)

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.7-05 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.7 — Medikamente |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.7-05](../../../../user-stories/eDMP_HKS/US-COPD-6.1.7-05.md) |

### Requirement

As a practice doctor, I want to document Sonstige diagnosespezifische Medikation with options Nein, Theophyllin, Inhalative GKS, Systemische GKS, or Andere, so that additional COPD-specific medications are tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Medikamente section is displayed, when Sonstige diagnosespezifische Medikation is presented, then one or more of Nein, Theophyllin, Inhalative GKS, Systemische GKS, Andere can be chosen
2. Given "Nein" is selected together with another option, when saved, then a validation error is raised

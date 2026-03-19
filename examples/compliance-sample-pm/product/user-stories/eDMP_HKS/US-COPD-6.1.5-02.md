## US-COPD-6.1.5-02 — Anamnese must capture COPD-specific Begleiterkrankungen

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.5-02 |
| **Traced from** | [COPD-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.5-02.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to select COPD-specific Begleiterkrankungen from the defined value set in the Anamnese section, so that comorbidities relevant to COPD management are documented per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Anamnese form is displayed, when Begleiterkrankungen is selected, then the COPD-specific comorbidity options are available
2. Given "Keine" is selected, when another comorbidity is also selected, then a validation error is raised

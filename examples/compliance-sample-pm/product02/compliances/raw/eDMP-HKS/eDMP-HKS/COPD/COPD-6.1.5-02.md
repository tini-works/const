## COPD-6.1.5-02 — Anamnese must capture COPD-specific Begleiterkrankungen

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.5-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.5-02](../../../../user-stories/eDMP_HKS/US-COPD-6.1.5-02.md) |

### Requirement

As a practice doctor, I want to select COPD-specific Begleiterkrankungen from the defined value set in the Anamnese section, so that comorbidities relevant to COPD management are documented per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Anamnese form is displayed, when Begleiterkrankungen is selected, then the COPD-specific comorbidity options are available
2. Given "Keine" is selected, when another comorbidity is also selected, then a validation error is raised

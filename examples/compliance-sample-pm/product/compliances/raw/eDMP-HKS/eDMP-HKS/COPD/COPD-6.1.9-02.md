## COPD-6.1.9-02 — Behandlungsplanung must capture Dokumentationsintervall

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.9-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.9-02](../../../../../user-stories/eDMP_HKS/US-COPD-6.1.9-02.md) |

### Requirement

As a practice doctor, I want to select the documentation interval (Dokumentationsintervall) for the eDMP COPD follow-up schedule, so that the follow-up frequency is defined per eDMP COPD treatment planning.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Dokumentationsintervall is presented, then a valid interval option must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

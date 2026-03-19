## US-COPD-6.1.9-02 — Behandlungsplanung must capture Dokumentationsintervall

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.9-02 |
| **Traced from** | [COPD-6.1.9-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.9-02.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to select the documentation interval (Dokumentationsintervall) for the eDMP COPD follow-up schedule, so that the follow-up frequency is defined per eDMP COPD treatment planning.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Dokumentationsintervall is presented, then a valid interval option must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

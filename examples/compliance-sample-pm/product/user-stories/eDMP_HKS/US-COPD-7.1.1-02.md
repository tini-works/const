## US-COPD-7.1.1-02 — Verlauf must capture Ungeplante aerztliche/stationaere Behandlung wegen COPD (Anzahl)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-7.1.1-02 |
| **Traced from** | [COPD-7.1.1-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-7.1.1-02.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the number of unplanned medical or inpatient treatments due to COPD (Ungeplante aerztliche/stationaere Behandlung wegen COPD: Anzahl), so that acute care utilization is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Verlauf section is displayed, when Ungeplante Behandlung is entered, then a non-negative integer count is accepted
2. Given a negative or non-numeric value is entered, when saved, then a validation error is raised

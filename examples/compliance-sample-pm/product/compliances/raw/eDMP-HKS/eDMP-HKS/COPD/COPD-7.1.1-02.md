## COPD-7.1.1-02 — Verlauf must capture Ungeplante aerztliche/stationaere Behandlung wegen COPD (Anzahl)

| Field | Value |
|-------|-------|
| **ID** | COPD-7.1.1-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 7.1.1 — Verlaufsdokumentation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-7.1.1-02](../../../../../user-stories/eDMP_HKS/US-COPD-7.1.1-02.md) |

### Requirement

As a practice doctor, I want to document the number of unplanned medical or inpatient treatments due to COPD (Ungeplante aerztliche/stationaere Behandlung wegen COPD: Anzahl), so that acute care utilization is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Verlauf section is displayed, when Ungeplante Behandlung is entered, then a non-negative integer count is accepted
2. Given a negative or non-numeric value is entered, when saved, then a validation error is raised

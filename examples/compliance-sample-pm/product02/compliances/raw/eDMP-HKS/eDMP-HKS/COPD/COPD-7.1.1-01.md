## COPD-7.1.1-01 — Verlauf must capture Haeufigkeit Exazerbationen seit letzter Dokumentation (Anzahl)

| Field | Value |
|-------|-------|
| **ID** | COPD-7.1.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 7.1.1 — Verlaufsdokumentation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-7.1.1-01](../../../../user-stories/eDMP_HKS/US-COPD-7.1.1-01.md) |

### Requirement

As a practice doctor, I want to document the number of exacerbations since the last documentation (Haeufigkeit Exazerbationen seit letzter Dokumentation: Anzahl), so that disease progression is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Verlauf section is displayed, when Haeufigkeit Exazerbationen is entered, then a non-negative integer count is accepted
2. Given a negative or non-numeric value is entered, when saved, then a validation error is raised

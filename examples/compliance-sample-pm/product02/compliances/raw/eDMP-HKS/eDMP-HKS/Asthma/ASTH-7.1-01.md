## ASTH-7.1-01 — Verlaufsdokumentation must capture Ungeplante Akutbehandlung seit letzter Dokumentation (Anzahl)

| Field | Value |
|-------|-------|
| **ID** | ASTH-7.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 7 — Verlaufsdokumentation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-7.1-01](../../../../user-stories/eDMP_HKS/US-ASTH-7.1-01.md) |

### Requirement

As a practice doctor, I want to document the number of unplanned acute treatments since the last documentation (Ungeplante Akutbehandlung seit letzter Dokumentation: Anzahl), so that exacerbation frequency is tracked per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Verlaufsdokumentation section is displayed, when Ungeplante Akutbehandlung is entered, then a non-negative integer count is accepted
2. Given a negative or non-numeric value is entered, when saved, then a validation error is raised

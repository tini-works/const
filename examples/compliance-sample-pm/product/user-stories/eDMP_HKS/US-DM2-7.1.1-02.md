## US-DM2-7.1.1-02 — Practice doctor must document Stationaere Notfallbehandlung wegen Diabetes mellitus as a count

| Field | Value |
|-------|-------|
| **ID** | US-DM2-7.1.1-02 |
| **Traced from** | [DM2-7.1.1-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-7.1.1-02.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the number of Stationaere Notfallbehandlungen wegen Diabetes mellitus in the Verlauf section, so that emergency hospital treatments are tracked for disease severity monitoring.

### Acceptance Criteria

1. Given an eDMP DM2 Verlauf section is documented, when Stationaere Notfallbehandlung is recorded, then a non-negative integer count is stored
2. Given a negative or non-numeric value is entered, when validated, then an error is reported

## US-DM1-6.1.9-02 — Practice doctor must document Dokumentationsintervall in the Behandlungsplanung section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.9-02 |
| **Traced from** | [DM1-6.1.9-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.9-02.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the planned Dokumentationsintervall in the Behandlungsplanung section, so that the next documentation interval is agreed and recorded for follow-up scheduling.

### Acceptance Criteria

1. Given an eDMP DM1 Behandlungsplanung is documented, when Dokumentationsintervall is recorded, then the interval value is stored
2. Given no interval is specified, when validated, then an error is reported

## US-DM1-6.1.9-05 — Practice doctor must document Diabetesbezogene stationaere Einweisung as Ja, Nein, or Veranlasst

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.9-05 |
| **Traced from** | [DM1-6.1.9-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.9-05.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Diabetesbezogene stationaere Einweisung as Ja, Nein, or Veranlasst in the Behandlungsplanung section, so that diabetes-related hospital admission referral status is documented.

### Acceptance Criteria

1. Given an eDMP DM1 Behandlungsplanung is documented, when stationaere Einweisung is recorded, then exactly one of Ja, Nein, or Veranlasst is selected
2. Given no value is selected, when validated, then an error is reported

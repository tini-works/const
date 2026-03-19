## US-DM1-6.1.7-01 — Practice doctor must document Thrombozytenaggregationshemmer status in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.7-01 |
| **Traced from** | [DM1-6.1.7-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.7-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Thrombozytenaggregationshemmer as Nein, Ja, Kontraindikation, or orale Antikoagulation in the Medikamente section, so that antiplatelet therapy status is captured for cardiovascular risk management.

### Acceptance Criteria

1. Given an eDMP DM1 Medikamente section is documented, when Thrombozytenaggregationshemmer is recorded, then exactly one of Nein, Ja, Kontraindikation, or orale Antikoagulation is selected
2. Given no value is selected, when validated, then an error is reported

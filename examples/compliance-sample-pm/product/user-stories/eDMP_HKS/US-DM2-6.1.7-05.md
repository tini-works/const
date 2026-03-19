## US-DM2-6.1.7-05 — Practice doctor must document Thiaziddiuretika status in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.7-05 |
| **Traced from** | [DM2-6.1.7-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.7-05.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Thiaziddiuretika as Nein, Ja, or Kontraindikation in the Medikamente section, so that thiazide diuretic therapy status is captured for hypertension management in diabetes.

### Acceptance Criteria

1. Given an eDMP DM2 Medikamente section is documented, when Thiaziddiuretika is recorded, then exactly one of Nein, Ja, or Kontraindikation is selected
2. Given no value is selected, when validated, then an error is reported

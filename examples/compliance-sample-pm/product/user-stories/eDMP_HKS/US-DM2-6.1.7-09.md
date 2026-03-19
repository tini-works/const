## US-DM2-6.1.7-09 — Practice doctor must document Sonstige antidiabetische Medikation as Nein or Ja in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.7-09 |
| **Traced from** | [DM2-6.1.7-09](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.7-09.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Sonstige antidiabetische Medikation as Nein or Ja in the Medikamente section, so that other antidiabetic medication status is captured for comprehensive therapy tracking.

### Acceptance Criteria

1. Given an eDMP DM2 Medikamente section is documented, when Sonstige antidiabetische Medikation is recorded, then exactly one of Nein or Ja is selected
2. Given no value is selected, when validated, then an error is reported

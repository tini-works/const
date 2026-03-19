## US-DM2-6.1.7-08 — Practice doctor must document Metformin as Nein, Ja, or Kontraindikation in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.7-08 |
| **Traced from** | [DM2-6.1.7-08](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.7-08.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Metformin as Nein, Ja, or Kontraindikation in the Medikamente section, so that metformin therapy status is captured for DM2 first-line therapy tracking.

### Acceptance Criteria

1. Given an eDMP DM2 Medikamente section is documented, when Metformin is recorded, then exactly one of Nein, Ja, or Kontraindikation is selected
2. Given no value is selected, when validated, then an error is reported

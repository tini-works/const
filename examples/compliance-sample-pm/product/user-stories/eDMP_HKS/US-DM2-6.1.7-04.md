## US-DM2-6.1.7-04 — Practice doctor must document HMG-CoA-Reduktase-Hemmer (Statin) status in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.7-04 |
| **Traced from** | [DM2-6.1.7-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.7-04.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document HMG-CoA-Reduktase-Hemmer as Nein, Ja, or Kontraindikation in the Medikamente section, so that statin therapy status is captured for lipid management in diabetes.

### Acceptance Criteria

1. Given an eDMP DM2 Medikamente section is documented, when HMG-CoA-Reduktase-Hemmer is recorded, then exactly one of Nein, Ja, or Kontraindikation is selected
2. Given no value is selected, when validated, then an error is reported

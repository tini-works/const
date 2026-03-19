## US-DM2-6.1.5-06 — Practice doctor must document Sensibilitaetspruefung as Nicht untersucht, Unauffaellig, or Auffaellig

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.5-06 |
| **Traced from** | [DM2-6.1.5-06](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.5-06.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the Sensibilitaetspruefung as Nicht untersucht, Unauffaellig, or Auffaellig in the Anamnese section, so that neuropathy screening status is captured for diabetic foot risk assessment.

### Acceptance Criteria

1. Given an eDMP DM2 Anamnese is documented, when Sensibilitaetspruefung is recorded, then exactly one of Nicht untersucht, Unauffaellig, or Auffaellig is selected
2. Given no value is selected, when validated, then an error is reported

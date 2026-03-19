## US-DM1-6.1.5-09 — Practice doctor must document (Wund)Infektion status as ja, nein, or nicht untersucht

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.5-09 |
| **Traced from** | [DM1-6.1.5-09](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.5-09.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document (Wund)Infektion as ja, nein, or nicht untersucht in the Anamnese section, so that wound infection status is captured for diabetic foot syndrome documentation.

### Acceptance Criteria

1. Given an eDMP DM1 Anamnese is documented, when (Wund)Infektion is recorded, then exactly one of ja, nein, or nicht untersucht is selected
2. Given no value is selected, when validated, then an error is reported

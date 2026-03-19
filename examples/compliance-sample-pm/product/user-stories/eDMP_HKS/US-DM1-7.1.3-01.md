## US-DM1-7.1.3-01 — Practice doctor must document Ophthalmologische Netzhautuntersuchung in the Verlauf section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-7.1.3-01 |
| **Traced from** | [DM1-7.1.3-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-7.1.3-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Ophthalmologische Netzhautuntersuchung as Durchgefuehrt, Nicht durchgefuehrt, or Veranlasst in the Verlauf section, so that retinal examination status is tracked for diabetic retinopathy screening.

### Acceptance Criteria

1. Given an eDMP DM1 Verlauf section is documented, when Ophthalmologische Netzhautuntersuchung is recorded, then exactly one of Durchgefuehrt, Nicht durchgefuehrt, or Veranlasst is selected
2. Given no value is selected, when validated, then an error is reported

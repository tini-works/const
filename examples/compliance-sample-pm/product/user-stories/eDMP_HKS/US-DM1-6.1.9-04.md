## US-DM1-6.1.9-04 — Practice doctor must document Behandlung Diabetisches Fusssyndrom as Ja, Nein, or Veranlasst

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.9-04 |
| **Traced from** | [DM1-6.1.9-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.9-04.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Behandlung Diabetisches Fusssyndrom as Ja, Nein, or Veranlasst in the Behandlungsplanung section, so that diabetic foot syndrome treatment status is captured for care coordination.

### Acceptance Criteria

1. Given an eDMP DM1 Behandlungsplanung is documented, when Behandlung Diabetisches Fusssyndrom is recorded, then exactly one of Ja, Nein, or Veranlasst is selected
2. Given no value is selected, when validated, then an error is reported

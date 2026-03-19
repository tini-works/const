## US-DM2-6.1.5-10 — Practice doctor must document Injektionsstellen bei Insulintherapie as Unauffaellig, Auffaellig, or Nicht untersucht

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.5-10 |
| **Traced from** | [DM2-6.1.5-10](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.5-10.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Injektionsstellen bei Insulintherapie as Unauffaellig, Auffaellig, or Nicht untersucht in the Anamnese section, so that injection site status is captured for insulin therapy quality monitoring.

### Acceptance Criteria

1. Given an eDMP DM2 Anamnese is documented, when Injektionsstellen is recorded, then exactly one of Unauffaellig, Auffaellig, or Nicht untersucht is selected
2. Given no value is selected, when validated, then an error is reported

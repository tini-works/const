## US-DM1-6.1.5-12 — Practice doctor must document Spaetfolgen as multi-select (Nephropathie, Neuropathie, Retinopathie)

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.5-12 |
| **Traced from** | [DM1-6.1.5-12](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.5-12.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Spaetfolgen selecting from Nephropathie, Neuropathie, and Retinopathie in the Anamnese section, so that late complications of diabetes are captured for disease progression monitoring.

### Acceptance Criteria

1. Given an eDMP DM1 Anamnese is documented, when Spaetfolgen is recorded, then one or more of Nephropathie, Neuropathie, or Retinopathie can be selected
2. Given no late complication is present, when documented, then no selection is made and the field remains empty or indicates none

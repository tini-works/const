## US-DM2-6.1.5-03 — Practice doctor must document Pathologische Albumin-Kreatinin-Ratio status in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.5-03 |
| **Traced from** | [DM2-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.5-03.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the Pathologische Albumin-Kreatinin-Ratio as Nicht untersucht, Ja, or Nein in the Anamnese section, so that kidney function screening status is captured for nephropathy monitoring.

### Acceptance Criteria

1. Given an eDMP DM2 Anamnese is documented, when the Albumin-Kreatinin-Ratio field is filled, then exactly one of Nicht untersucht, Ja, or Nein is recorded
2. Given no value is selected, when validated, then an error is reported

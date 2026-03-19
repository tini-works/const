## US-DM1-6.1.5-01 — Practice doctor must document Koerpergroesse, Koerpergewicht, Raucherstatus, and Blutdruck in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.5-01 |
| **Traced from** | [DM1-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.5-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Koerpergroesse, Koerpergewicht, Raucherstatus, and Blutdruck in the Anamnese section, so that the vital parameters are captured for DM1 monitoring and quality reporting.

### Acceptance Criteria

1. Given an eDMP DM1 Anamnese is documented, when the form is completed, then Koerpergroesse (cm), Koerpergewicht (kg), Raucher (Ja/Nein), and Blutdruck (systolisch/diastolisch mmHg) are recorded
2. Given any of these four fields is missing, when validated, then an error is reported

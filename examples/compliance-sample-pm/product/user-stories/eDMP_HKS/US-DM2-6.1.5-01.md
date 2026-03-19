## US-DM2-6.1.5-01 — Practice doctor must document Koerpergroesse, Koerpergewicht, Raucherstatus, and Blutdruck in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.5-01 |
| **Traced from** | [DM2-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.5-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Koerpergroesse, Koerpergewicht, Raucherstatus, and Blutdruck in the Anamnese section, so that the vital parameters are captured for DM2 monitoring and quality reporting.

### Acceptance Criteria

1. Given an eDMP DM2 Anamnese is documented, when the form is completed, then Koerpergroesse (cm), Koerpergewicht (kg), Raucher (Ja/Nein), and Blutdruck (systolisch/diastolisch mmHg) are recorded
2. Given any of these four fields is missing, when validated, then an error is reported

## US-DM2-6.1.7-10 — Practice doctor must document SGLT2-Inhibitor as Nein, Ja, or Kontraindikation in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.7-10 |
| **Traced from** | [DM2-6.1.7-10](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.7-10.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document SGLT2-Inhibitor as Nein, Ja, or Kontraindikation in the Medikamente section, so that SGLT2 inhibitor therapy status is captured for modern DM2 therapy tracking.

### Acceptance Criteria

1. Given an eDMP DM2 Medikamente section is documented, when SGLT2-Inhibitor is recorded, then exactly one of Nein, Ja, or Kontraindikation is selected
2. Given no value is selected, when validated, then an error is reported

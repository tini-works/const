## US-DM1-6.1.7-03 — Practice doctor must document ACE-Hemmer status in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.7-03 |
| **Traced from** | [DM1-6.1.7-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.7-03.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document ACE-Hemmer as Nein, Ja, Kontraindikation, or ARB in the Medikamente section, so that ACE inhibitor therapy status is captured for renal and cardiovascular protection.

### Acceptance Criteria

1. Given an eDMP DM1 Medikamente section is documented, when ACE-Hemmer is recorded, then exactly one of Nein, Ja, Kontraindikation, or ARB is selected
2. Given no value is selected, when validated, then an error is reported

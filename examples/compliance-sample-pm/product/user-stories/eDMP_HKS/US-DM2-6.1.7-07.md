## US-DM2-6.1.7-07 — Practice doctor must document Glibenclamid as Nein, Ja, or Kontraindikation in the Medikamente section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.7-07 |
| **Traced from** | [DM2-6.1.7-07](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.7-07.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Glibenclamid as Nein, Ja, or Kontraindikation in the Medikamente section, so that glibenclamide therapy status is captured for DM2 oral antidiabetic tracking.

### Acceptance Criteria

1. Given an eDMP DM2 Medikamente section is documented, when Glibenclamid is recorded, then exactly one of Nein, Ja, or Kontraindikation is selected
2. Given no value is selected, when validated, then an error is reported

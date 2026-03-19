## US-DM2-6.1.6-01 — Practice doctor must document Relevante Ereignisse as multi-select in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.6-01 |
| **Traced from** | [DM2-6.1.6-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.6-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Relevante Ereignisse selecting from Nierenersatztherapie, Erblindung, Amputation, Herzinfarkt, Schlaganfall, or Keine, so that significant clinical events since last documentation are recorded for outcome tracking.

### Acceptance Criteria

1. Given an eDMP DM2 Anamnese is documented, when Relevante Ereignisse is recorded, then one or more of Nierenersatztherapie, Erblindung, Amputation, Herzinfarkt, Schlaganfall, or Keine is selected
2. Given "Keine" is selected together with another event, when validated, then an error is reported

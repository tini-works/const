## US-DM2-6.1.5-04 — Practice doctor must document eGFR as a numeric value in ml/min/1,73m2KOF or as Nicht bestimmt

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.5-04 |
| **Traced from** | [DM2-6.1.5-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.5-04.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document eGFR either as a numeric value in ml/min/1,73m2KOF or as "Nicht bestimmt" in the Anamnese section, so that renal function data is captured with conditional type support for cases where eGFR was not determined.

### Acceptance Criteria

1. Given an eGFR measurement is available, when documented, then the numeric value in ml/min/1,73m2KOF is recorded
2. Given eGFR was not determined, when documented, then "Nicht bestimmt" is recorded
3. Given neither a numeric value nor "Nicht bestimmt" is provided, when validated, then an error is reported

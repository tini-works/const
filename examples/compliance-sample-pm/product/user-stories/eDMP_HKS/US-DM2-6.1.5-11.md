## US-DM2-6.1.5-11 — Practice doctor must document Intervall kuenftige Fussinspektionen ab 18. Lebensjahr

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.5-11 |
| **Traced from** | [DM2-6.1.5-11](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.5-11.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the interval for future foot inspections (ab 18. Lebensjahr) as Jaehrlich, alle 6 Monate, or alle 3 Monate oder haeufiger, so that the planned foot inspection frequency is documented for patients aged 18 and over.

### Acceptance Criteria

1. Given an eDMP DM2 Anamnese is documented for a patient aged 18 or older, when Intervall kuenftige Fussinspektionen is recorded, then exactly one of Jaehrlich, alle 6 Monate, or alle 3 Monate oder haeufiger is selected
2. Given the patient is under 18 years, when the field is presented, then it may be omitted or marked as not applicable
3. Given no value is selected for an eligible patient, when validated, then an error is reported

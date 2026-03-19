## US-DM2-6.1.5-02 — Practice doctor must document HbA1c with dual unit support (% or mmol/mol) in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.5-02 |
| **Traced from** | [DM2-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.5-02.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document HbA1c in either percent (%) or mmol/mol in the Anamnese section, so that the HbA1c value is recorded in the unit used by the laboratory and both units are supported.

### Acceptance Criteria

1. Given an eDMP DM2 HbA1c value is entered in %, when stored, then it is accepted and correctly encoded
2. Given an eDMP DM2 HbA1c value is entered in mmol/mol, when stored, then it is accepted and correctly encoded
3. Given no HbA1c value is provided, when validated, then an error is reported

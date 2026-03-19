## US-DM1-6.1.5-07 — Practice doctor must document Weiteres Risiko fuer Ulcus as a multi-select field in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.5-07 |
| **Traced from** | [DM1-6.1.5-07](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.5-07.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Weiteres Risiko fuer Ulcus selecting from Fussdeformitaet, Hyperkeratose, Z.n. Ulcus, Z.n. Amputation, ja, nein, or nicht untersucht, so that additional ulcer risk factors are captured as multi-select for diabetic foot syndrome assessment.

### Acceptance Criteria

1. Given an eDMP DM1 Anamnese is documented, when Weiteres Risiko fuer Ulcus is recorded, then one or more of Fussdeformitaet, Hyperkeratose, Z.n. Ulcus, Z.n. Amputation, ja, nein, or nicht untersucht is selected
2. Given no value is selected, when validated, then an error is reported
3. Given mutually exclusive values are selected (e.g., nein and ja simultaneously), when validated, then an error is reported

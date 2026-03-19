## US-COPD-6.1.5-01 — Anamnese must capture Koerpergroesse, Koerpergewicht, Raucher status, and Blutdruck

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.5-01 |
| **Traced from** | [COPD-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.5-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Koerpergroesse (cm), Koerpergewicht (kg), Raucher status (Ja/Nein/Nicht erhoben), and Blutdruck systolisch/diastolisch (mmHg) in the Anamnese section, so that the patient's basic physical data is recorded per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD documentation is opened, when Anamnese is entered, then fields for Koerpergroesse (cm), Koerpergewicht (kg), Raucher (Ja/Nein/Nicht erhoben), and Blutdruck systolisch/diastolisch (mmHg) are available
2. Given values are outside plausible ranges, when saved, then a validation warning is displayed
3. Given mandatory fields are not filled, when the form is submitted, then a mandatory field error is raised

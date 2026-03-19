## US-ASTH-6.1.5-01 — Anamnese must capture Koerpergroesse (cm), Koerpergewicht (kg), and Raucher status

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.5-01 |
| **Traced from** | [ASTH-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.5-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Koerpergroesse in cm, Koerpergewicht in kg, and Raucher status (Ja/Nein/Nicht erhoben) in the Anamnese section, so that the patient's basic physical data is recorded per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is opened, when Anamnese is entered, then fields for Koerpergroesse (cm), Koerpergewicht (kg), and Raucher (Ja/Nein/Nicht erhoben) are available
2. Given Koerpergroesse or Koerpergewicht values are outside plausible ranges, when saved, then a validation warning is displayed
3. Given Raucher status is not selected, when the form is submitted, then a mandatory field error is raised

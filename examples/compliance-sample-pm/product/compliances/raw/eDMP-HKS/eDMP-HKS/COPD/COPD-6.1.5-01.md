## COPD-6.1.5-01 — Anamnese must capture Koerpergroesse, Koerpergewicht, Raucher status, and Blutdruck

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.5-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.5-01](../../../../../user-stories/eDMP_HKS/US-COPD-6.1.5-01.md) |

### Requirement

As a practice doctor, I want to document Koerpergroesse (cm), Koerpergewicht (kg), Raucher status (Ja/Nein/Nicht erhoben), and Blutdruck systolisch/diastolisch (mmHg) in the Anamnese section, so that the patient's basic physical data is recorded per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD documentation is opened, when Anamnese is entered, then fields for Koerpergroesse (cm), Koerpergewicht (kg), Raucher (Ja/Nein/Nicht erhoben), and Blutdruck systolisch/diastolisch (mmHg) are available
2. Given values are outside plausible ranges, when saved, then a validation warning is displayed
3. Given mandatory fields are not filled, when the form is submitted, then a mandatory field error is raised

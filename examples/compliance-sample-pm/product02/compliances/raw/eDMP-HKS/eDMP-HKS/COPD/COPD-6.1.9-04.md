## COPD-6.1.9-04 — Behandlungsplanung must capture Empfehlung Tabakverzicht (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.9-04 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.9-04](../../../../user-stories/eDMP_HKS/US-COPD-6.1.9-04.md) |

### Requirement

As a practice doctor, I want to document whether tobacco abstinence was recommended (Empfehlung Tabakverzicht: Ja/Nein), so that smoking cessation counseling is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Empfehlung Tabakverzicht is presented, then Ja or Nein must be selected
2. Given the patient is documented as Raucher = Ja, when Empfehlung Tabakverzicht = Nein, then a plausibility warning may be raised

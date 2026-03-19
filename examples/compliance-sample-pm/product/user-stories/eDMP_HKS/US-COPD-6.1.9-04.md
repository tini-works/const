## US-COPD-6.1.9-04 — Behandlungsplanung must capture Empfehlung Tabakverzicht (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.9-04 |
| **Traced from** | [COPD-6.1.9-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.9-04.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether tobacco abstinence was recommended (Empfehlung Tabakverzicht: Ja/Nein), so that smoking cessation counseling is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Empfehlung Tabakverzicht is presented, then Ja or Nein must be selected
2. Given the patient is documented as Raucher = Ja, when Empfehlung Tabakverzicht = Nein, then a plausibility warning may be raised

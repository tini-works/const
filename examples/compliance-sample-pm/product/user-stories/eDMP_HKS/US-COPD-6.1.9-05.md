## US-COPD-6.1.9-05 — Behandlungsplanung must capture Empfehlung Tabakentwoehnung (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.9-05 |
| **Traced from** | [COPD-6.1.9-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.9-05.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether tobacco cessation program was recommended (Empfehlung Tabakentwoehnung: Ja/Nein), so that structured smoking cessation support is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Empfehlung Tabakentwoehnung is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

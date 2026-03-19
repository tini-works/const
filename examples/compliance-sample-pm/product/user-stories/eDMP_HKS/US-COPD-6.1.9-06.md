## US-COPD-6.1.9-06 — Behandlungsplanung must capture Empfehlung koerperliches Training (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.9-06 |
| **Traced from** | [COPD-6.1.9-06](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.9-06.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether physical training was recommended (Empfehlung koerperliches Training: Ja/Nein), so that exercise recommendations are tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Empfehlung koerperliches Training is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

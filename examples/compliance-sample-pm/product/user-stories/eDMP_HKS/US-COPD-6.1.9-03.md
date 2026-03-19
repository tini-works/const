## US-COPD-6.1.9-03 — Behandlungsplanung must capture COPD-bezogene Ueberweisung veranlasst (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.9-03 |
| **Traced from** | [COPD-6.1.9-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.9-03.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether a COPD-related referral was initiated (COPD-bezogene Ueberweisung veranlasst: Ja/Nein), so that specialist referral decisions are tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when COPD-bezogene Ueberweisung veranlasst is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

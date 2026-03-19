## US-COPD-6.1.7-04 — Medikamente must capture Inhalationstechnik ueberprueft (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.7-04 |
| **Traced from** | [COPD-6.1.7-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.7-04.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether inhalation technique was checked (Inhalationstechnik ueberprueft: Ja/Nein), so that patient education on inhaler use is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Medikamente section is displayed, when Inhalationstechnik ueberprueft is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

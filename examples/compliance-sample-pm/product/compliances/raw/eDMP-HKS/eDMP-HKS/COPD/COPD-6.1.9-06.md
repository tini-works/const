## COPD-6.1.9-06 — Behandlungsplanung must capture Empfehlung koerperliches Training (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.9-06 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.9-06](../../../../../user-stories/eDMP_HKS/US-COPD-6.1.9-06.md) |

### Requirement

As a practice doctor, I want to document whether physical training was recommended (Empfehlung koerperliches Training: Ja/Nein), so that exercise recommendations are tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Empfehlung koerperliches Training is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

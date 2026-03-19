## COPD-6.1.8-01 — Schulung must capture COPD-Schulung empfohlen (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.8-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.8 — Schulung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.8-01](../../../../../user-stories/eDMP_HKS/US-COPD-6.1.8-01.md) |

### Requirement

As a practice doctor, I want to document whether a COPD training was recommended (COPD-Schulung empfohlen: Ja/Nein), so that patient education recommendations are tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Schulung section is displayed, when COPD-Schulung empfohlen is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

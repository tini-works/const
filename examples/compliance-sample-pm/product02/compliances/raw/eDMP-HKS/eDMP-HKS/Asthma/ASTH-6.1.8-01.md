## ASTH-6.1.8-01 — Schulung must capture Asthma-Schulung empfohlen (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.8-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.8 — Schulung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.8-01](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.8-01.md) |

### Requirement

As a practice doctor, I want to document whether an Asthma training was recommended (Asthma-Schulung empfohlen: Ja/Nein), so that patient education recommendations are tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Schulung section is displayed, when Asthma-Schulung empfohlen is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

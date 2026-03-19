## COPD-6.1.8-02 — Schulung must capture Schulung vor Einschreibung wahrgenommen (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.8-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.8 — Schulung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.8-02](../../../../user-stories/eDMP_HKS/US-COPD-6.1.8-02.md) |

### Requirement

As a practice doctor, I want to document whether the patient attended a COPD training before enrollment (Schulung vor Einschreibung wahrgenommen: Ja/Nein), so that prior education status is recorded per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Schulung section is displayed, when Schulung vor Einschreibung is presented, then Ja or Nein must be selected
2. Given this is a Folgedokumentation, when the field is displayed, then it should not be editable (applies only to Erstdokumentation)

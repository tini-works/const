## ASTH-6.1.8-02 — Schulung must capture Asthma-Schulung vor Einschreibung wahrgenommen (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.8-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.8 — Schulung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.8-02](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.8-02.md) |

### Requirement

As a practice doctor, I want to document whether the patient attended an Asthma training before enrollment (Asthma-Schulung vor Einschreibung wahrgenommen: Ja/Nein), so that prior education status is recorded per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Schulung section is displayed, when Schulung vor Einschreibung is presented, then Ja or Nein must be selected
2. Given this is a Folgedokumentation, when the field is displayed, then it should not be editable (applies only to Erstdokumentation)

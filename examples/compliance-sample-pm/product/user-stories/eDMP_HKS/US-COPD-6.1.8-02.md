## US-COPD-6.1.8-02 — Schulung must capture Schulung vor Einschreibung wahrgenommen (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.8-02 |
| **Traced from** | [COPD-6.1.8-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.8-02.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the patient attended a COPD training before enrollment (Schulung vor Einschreibung wahrgenommen: Ja/Nein), so that prior education status is recorded per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP COPD Schulung section is displayed, when Schulung vor Einschreibung is presented, then Ja or Nein must be selected
2. Given this is a Folgedokumentation, when the field is displayed, then it should not be editable (applies only to Erstdokumentation)

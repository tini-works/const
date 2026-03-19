## US-HI-6.1.8-02 — When a doctor documents eDMP HI training, Schulung vor Einschreibung wahrgenommen must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.8-02 |
| **Traced from** | [HI-6.1.8-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.8-02.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the patient attended training before enrollment (Schulung vor Einschreibung wahrgenommen), so that prior education status is recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Schulung section is displayed, then a Schulung vor Einschreibung wahrgenommen field is available
2. Given a value is selected, when the XML is generated, then it is encoded correctly

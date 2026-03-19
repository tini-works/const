## US-HI-7.1-02 — When a doctor documents eDMP HI follow-up, empfohlene Schulung wahrgenommen must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-7.1-02 |
| **Traced from** | [HI-7.1-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-7.1-02.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the recommended training was attended (empfohlene Schulung wahrgenommen) in the follow-up section, so that patient education compliance is tracked per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Verlauf section is displayed, then a field for empfohlene Schulung wahrgenommen is available
2. Given a value is selected, when the XML is generated, then it is encoded correctly

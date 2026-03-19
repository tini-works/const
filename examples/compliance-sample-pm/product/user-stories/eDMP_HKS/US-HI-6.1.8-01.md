## US-HI-6.1.8-01 — When a doctor documents eDMP HI training, HI-Schulung empfohlen must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.8-01 |
| **Traced from** | [HI-6.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.8-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether an HI-specific training (HI-Schulung) is recommended, so that the patient education recommendation is recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Schulung section is displayed, then an HI-Schulung empfohlen field is available
2. Given a recommendation is made, when the XML is generated, then the Schulung empfohlen value is encoded correctly

## US-HI-6.1.7-05 — When a doctor documents eDMP HI medication, sonstige HI-spezifische Medikation must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.7-05 |
| **Traced from** | [HI-6.1.7-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.7-05.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document sonstige HI-spezifische Medikation in the HI medication section, so that additional heart failure-specific medications are recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the medication section is displayed, then a field for sonstige HI-spezifische Medikation is available
2. Given medication data is entered, when the XML is generated, then the values are encoded correctly

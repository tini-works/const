## US-HI-6.1.5-01 — When a doctor documents eDMP HI anamnesis, Koerpergroesse, Koerpergewicht, Raucher, and Blutdruck must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.5-01 |
| **Traced from** | [HI-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.5-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Koerpergroesse, Koerpergewicht, Raucher status, and Blutdruck in the HI anamnesis section, so that the required vital parameters are captured per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then fields for Koerpergroesse, Koerpergewicht, Raucher, and Blutdruck are present
2. Given all four fields are completed, when the XML is generated, then each value is encoded in the correct Sciphox-SSU element
3. Given a required field is missing, when validation is triggered, then a warning is displayed

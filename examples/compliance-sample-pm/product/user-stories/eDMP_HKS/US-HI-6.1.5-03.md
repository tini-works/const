## US-HI-6.1.5-03 — When a doctor documents eDMP HI anamnesis, ejection fraction data must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.5-03 |
| **Traced from** | [HI-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.5-03.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the ejection fraction in the HI anamnesis section, so that the left ventricular function is recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then an ejection fraction field is available
2. Given the ejection fraction value is entered, when the XML is generated, then the value is encoded in the correct observation element
3. Given the ejection fraction is outside the valid range, when validation is triggered, then an error is displayed

## US-HI-6.1.5-02 — When a doctor documents eDMP HI anamnesis, NYHA classification must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.5-02 |
| **Traced from** | [HI-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.5-02.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the NYHA classification in the HI anamnesis section, so that the heart failure functional class is systematically recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then a NYHA classification field is available with options I through IV
2. Given a NYHA class is selected, when the XML is generated, then the classification value is encoded in the correct observation element

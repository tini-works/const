## US-HI-6.1.5-04 — When a doctor documents eDMP HI anamnesis, HI-specific Begleiterkrankungen must be documented

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.5-04 |
| **Traced from** | [HI-6.1.5-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.5-04.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document HI-specific comorbidities (Begleiterkrankungen) in the anamnesis section, so that relevant accompanying diseases are recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then HI-specific comorbidity fields are available
2. Given comorbidities are documented, when the XML is generated, then each Begleiterkrankung is encoded in the correct HI-specific element

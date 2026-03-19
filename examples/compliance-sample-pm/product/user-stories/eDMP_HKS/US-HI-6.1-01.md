## US-HI-6.1-01 — When practice software generates eDMP HI XML, section/paragraph structure must use HI caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1-01 |
| **Traced from** | [HI-6.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to structure the eDMP HI XML with section and paragraph elements using HI-specific caption_cd DN values, so that each documentation section is correctly identified and parseable.

### Acceptance Criteria

1. Given an eDMP HI XML is generated, when sections are created, then each section uses the correct HI caption_cd DN value
2. Given a paragraph element, when its caption_cd is checked, then it matches the HI V1.03 specification

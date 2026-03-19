## US-DEP-6.1-01 — When practice software generates eDMP Depression XML, section/paragraph structure must use Depression caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1-01 |
| **Traced from** | [DEP-6.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to structure the eDMP Depression XML with section and paragraph elements using Depression-specific caption_cd DN values, so that each documentation section is correctly identified and parseable.

### Acceptance Criteria

1. Given an eDMP Depression XML is generated, when sections are created, then each section uses the correct Depression caption_cd DN value
2. Given a paragraph element, when its caption_cd is checked, then it matches the Depression V1.02 specification

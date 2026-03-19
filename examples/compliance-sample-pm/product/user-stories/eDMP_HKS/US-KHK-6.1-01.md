## US-KHK-6.1-01 — When practice software generates eDMP KHK XML, section/paragraph structure must use KHK caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1-01 |
| **Traced from** | [KHK-6.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to structure the eDMP KHK XML with section and paragraph elements using KHK-specific caption_cd DN values, so that each documentation section is correctly identified and parseable.

### Acceptance Criteria

1. Given an eDMP KHK XML is generated, when sections are created, then each section uses the correct KHK caption_cd DN value
2. Given a paragraph element, when its caption_cd is checked, then it matches the KHK V4.16 specification

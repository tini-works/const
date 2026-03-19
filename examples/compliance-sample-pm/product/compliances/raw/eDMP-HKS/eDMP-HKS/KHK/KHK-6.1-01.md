## KHK-6.1-01 — When practice software generates eDMP KHK XML, section/paragraph structure must use KHK caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1 — eBody Gliederung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-KHK-6.1-01](../../../../user-stories/eDMP_HKS/US-KHK-6.1-01.md) |

### Requirement

When practice software generates eDMP KHK XML, section/paragraph structure must use KHK caption_cd DN values

### Acceptance Criteria

1. Given an eDMP KHK XML is generated, when sections are created, then each section uses the correct KHK caption_cd DN value
2. Given a paragraph element, when its caption_cd is checked, then it matches the KHK V4.16 specification

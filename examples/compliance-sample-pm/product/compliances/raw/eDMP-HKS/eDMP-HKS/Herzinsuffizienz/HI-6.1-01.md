## HI-6.1-01 — When practice software generates eDMP HI XML, section/paragraph structure must use HI caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | HI-6.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1 — eBody Gliederung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-HI-6.1-01](../../../../user-stories/eDMP_HKS/US-HI-6.1-01.md) |

### Requirement

When practice software generates eDMP HI XML, section/paragraph structure must use HI caption_cd DN values

### Acceptance Criteria

1. Given an eDMP HI XML is generated, when sections are created, then each section uses the correct HI caption_cd DN value
2. Given a paragraph element, when its caption_cd is checked, then it matches the HI V1.03 specification

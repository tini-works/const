## DEP-6.1-01 — When practice software generates eDMP Depression XML, section/paragraph structure must use Depression caption_cd DN values

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1 — eBody Gliederung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-DEP-6.1-01](../../../../../user-stories/eDMP_HKS/US-DEP-6.1-01.md) |

### Requirement

When practice software generates eDMP Depression XML, section/paragraph structure must use Depression caption_cd DN values

### Acceptance Criteria

1. Given an eDMP Depression XML is generated, when sections are created, then each section uses the correct Depression caption_cd DN value
2. Given a paragraph element, when its caption_cd is checked, then it matches the Depression V1.02 specification

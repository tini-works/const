## KHK-5.1-01 — When practice software generates eDMP KHK XML, eHeader must contain KHK-specific elements

| Field | Value |
|-------|-------|
| **ID** | KHK-5.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 5.1 — eHeader |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-KHK-5.1-01](../../../../user-stories/eDMP_HKS/US-KHK-5.1-01.md) |

### Requirement

When practice software generates eDMP KHK XML, eHeader must contain KHK-specific elements

### Acceptance Criteria

1. Given an eDMP KHK documentation is exported, when the eHeader is generated, then KHK-specific KBV module identifiers are included
2. Given the eHeader, when compared to the general eDMP eHeader, then all KHK-specific deviations per V4.16 are applied

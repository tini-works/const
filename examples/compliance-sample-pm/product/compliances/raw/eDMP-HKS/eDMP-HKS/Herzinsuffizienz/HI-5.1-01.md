## HI-5.1-01 — When practice software generates eDMP HI XML, eHeader must contain HI-specific elements

| Field | Value |
|-------|-------|
| **ID** | HI-5.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 5.1 — eHeader |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-HI-5.1-01](../../../../../user-stories/eDMP_HKS/US-HI-5.1-01.md) |

### Requirement

When practice software generates eDMP HI XML, eHeader must contain HI-specific elements

### Acceptance Criteria

1. Given an eDMP HI documentation is exported, when the eHeader is generated, then HI-specific KBV module identifiers are included
2. Given the eHeader, when compared to the general eDMP eHeader, then all HI-specific deviations per V1.03 are applied

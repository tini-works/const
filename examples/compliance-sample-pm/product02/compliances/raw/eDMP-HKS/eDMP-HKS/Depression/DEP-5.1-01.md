## DEP-5.1-01 — When practice software generates eDMP Depression XML, eHeader must contain Depression-specific elements

| Field | Value |
|-------|-------|
| **ID** | DEP-5.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 5.1 — eHeader |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-DEP-5.1-01](../../../../user-stories/eDMP_HKS/US-DEP-5.1-01.md) |

### Requirement

When practice software generates eDMP Depression XML, eHeader must contain Depression-specific elements

### Acceptance Criteria

1. Given an eDMP Depression documentation is exported, when the eHeader is generated, then Depression-specific KBV module identifiers are included
2. Given the eHeader, when compared to the general eDMP eHeader, then all Depression-specific deviations per V1.02 are applied

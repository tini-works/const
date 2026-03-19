## US-DEP-5.1-01 — When practice software generates eDMP Depression XML, eHeader must contain Depression-specific elements

| Field | Value |
|-------|-------|
| **ID** | US-DEP-5.1-01 |
| **Traced from** | [DEP-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-5.1-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate the eHeader with Depression-specific differences from the general eDMP eHeader, so that the document is correctly identified as an eDMP Depression documentation.

### Acceptance Criteria

1. Given an eDMP Depression documentation is exported, when the eHeader is generated, then Depression-specific KBV module identifiers are included
2. Given the eHeader, when compared to the general eDMP eHeader, then all Depression-specific deviations per V1.02 are applied

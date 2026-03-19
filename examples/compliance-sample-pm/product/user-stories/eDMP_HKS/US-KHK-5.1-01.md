## US-KHK-5.1-01 — When practice software generates eDMP KHK XML, eHeader must contain KHK-specific elements

| Field | Value |
|-------|-------|
| **ID** | US-KHK-5.1-01 |
| **Traced from** | [KHK-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-5.1-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate the eHeader with KHK-specific differences from the general eDMP eHeader, so that the document is correctly identified as an eDMP KHK documentation.

### Acceptance Criteria

1. Given an eDMP KHK documentation is exported, when the eHeader is generated, then KHK-specific KBV module identifiers are included
2. Given the eHeader, when compared to the general eDMP eHeader, then all KHK-specific deviations per V4.16 are applied

## BK-5.1-01 — Practice software must include a correct eHeader with Brustkrebs-specific fields in eDMP Brustkrebs documents

| Field | Value |
|-------|-------|
| **ID** | BK-5.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 5.1 -- eHeader |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-BK-5.1-01](../../../../../user-stories/eDMP_HKS/US-BK-5.1-01.md) |

### Requirement

As a practice software, I want to include a correct eHeader with Brustkrebs-specific differences in every eDMP Brustkrebs CDA document, so that the document header identifies the DMP module and version unambiguously.

### Acceptance Criteria

1. Given an eDMP Brustkrebs document is generated, when the eHeader is written, then it contains Brustkrebs-specific code and version identifiers
2. Given an eHeader missing Brustkrebs-specific fields, when validated, then an error is reported

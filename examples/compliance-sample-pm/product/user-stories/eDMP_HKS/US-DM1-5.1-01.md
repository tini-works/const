## US-DM1-5.1-01 — Practice software must include a correct eHeader with DM1-specific fields in eDMP DM1 documents

| Field | Value |
|-------|-------|
| **ID** | US-DM1-5.1-01 |
| **Traced from** | [DM1-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-5.1-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to include a correct eHeader with DM1-specific differences in every eDMP DM1 CDA document, so that the document header identifies the DMP module and version unambiguously.

### Acceptance Criteria

1. Given an eDMP DM1 document is generated, when the eHeader is written, then it contains DM1-specific code and version identifiers
2. Given an eHeader missing DM1-specific fields, when validated, then an error is reported

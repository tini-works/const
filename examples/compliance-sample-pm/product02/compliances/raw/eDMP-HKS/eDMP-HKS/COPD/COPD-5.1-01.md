## COPD-5.1-01 — Practice software must generate eHeader conforming to eHeader spec with COPD-specific differences

| Field | Value |
|-------|-------|
| **ID** | COPD-5.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 5.1 — eHeader |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-COPD-5.1-01](../../../../user-stories/eDMP_HKS/US-COPD-5.1-01.md) |

### Requirement

As a practice software, I want to generate the clinical_document_header conforming to the eHeader specification with COPD-specific differences applied, so that the header metadata is correct for eDMP COPD transmissions.

### Acceptance Criteria

1. Given an eDMP COPD document is created, when the header is generated, then it conforms to the eHeader specification
2. Given COPD-specific header fields differ from the generic eHeader, when the header is generated, then the COPD-specific values are used

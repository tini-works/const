## ASTH-5.1-01 — Practice software must generate eHeader conforming to eHeader spec with Asthma-specific differences

| Field | Value |
|-------|-------|
| **ID** | ASTH-5.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 5.1 — eHeader |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-ASTH-5.1-01](../../../../../user-stories/eDMP_HKS/US-ASTH-5.1-01.md) |

### Requirement

As a practice software, I want to generate the clinical_document_header conforming to the eHeader specification with Asthma-specific differences applied, so that the header metadata is correct for eDMP Asthma transmissions.

### Acceptance Criteria

1. Given an eDMP Asthma document is created, when the header is generated, then it conforms to the eHeader specification
2. Given Asthma-specific header fields differ from the generic eHeader, when the header is generated, then the Asthma-specific values are used

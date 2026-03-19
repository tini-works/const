## US-ASTH-5.1-01 — Practice software must generate eHeader conforming to eHeader spec with Asthma-specific differences

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-5.1-01 |
| **Traced from** | [ASTH-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-5.1-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate the clinical_document_header conforming to the eHeader specification with Asthma-specific differences applied, so that the header metadata is correct for eDMP Asthma transmissions.

### Acceptance Criteria

1. Given an eDMP Asthma document is created, when the header is generated, then it conforms to the eHeader specification
2. Given Asthma-specific header fields differ from the generic eHeader, when the header is generated, then the Asthma-specific values are used

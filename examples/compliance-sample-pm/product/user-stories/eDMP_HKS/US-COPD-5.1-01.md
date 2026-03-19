## US-COPD-5.1-01 — Practice software must generate eHeader conforming to eHeader spec with COPD-specific differences

| Field | Value |
|-------|-------|
| **ID** | US-COPD-5.1-01 |
| **Traced from** | [COPD-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-5.1-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate the clinical_document_header conforming to the eHeader specification with COPD-specific differences applied, so that the header metadata is correct for eDMP COPD transmissions.

### Acceptance Criteria

1. Given an eDMP COPD document is created, when the header is generated, then it conforms to the eHeader specification
2. Given COPD-specific header fields differ from the generic eHeader, when the header is generated, then the COPD-specific values are used

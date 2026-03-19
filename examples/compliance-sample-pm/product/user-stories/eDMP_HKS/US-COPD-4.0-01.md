## US-COPD-4.0-01 — Practice software must produce eDMP COPD XML following CDA levelone structure with clinical_document_header and body

| Field | Value |
|-------|-------|
| **ID** | US-COPD-4.0-01 |
| **Traced from** | [COPD-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-4.0-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to produce eDMP COPD XML documents following the CDA levelone structure with clinical_document_header and body elements, so that the documentation is structurally valid per KBV requirements.

### Acceptance Criteria

1. Given an eDMP COPD documentation is generated, when the XML is produced, then it contains a valid clinical_document_header and body as top-level elements
2. Given the XML is missing clinical_document_header or body, when validated, then a structural error is reported

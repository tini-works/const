## US-ASTH-4.0-01 — Practice software must produce eDMP Asthma XML following CDA levelone structure with clinical_document_header and body

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-4.0-01 |
| **Traced from** | [ASTH-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-4.0-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to produce eDMP Asthma XML documents following the CDA levelone structure with clinical_document_header and body elements, so that the documentation is structurally valid per KBV requirements.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is generated, when the XML is produced, then it contains a valid clinical_document_header and body as top-level elements
2. Given the XML is missing clinical_document_header or body, when validated, then a structural error is reported

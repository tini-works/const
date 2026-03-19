## US-BK-4.0-01 — Practice software must produce eDMP Brustkrebs documents as valid CDA levelone XML

| Field | Value |
|-------|-------|
| **ID** | US-BK-4.0-01 |
| **Traced from** | [BK-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-4.0-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to produce eDMP Brustkrebs documentation as valid CDA levelone XML documents, so that the documents conform to the HL7 CDA standard and can be processed by receiving systems.

### Acceptance Criteria

1. Given an eDMP Brustkrebs documentation is created, when the XML is generated, then it is a valid CDA levelone document
2. Given a document missing required CDA levelone elements, when validated, then a schema error is reported

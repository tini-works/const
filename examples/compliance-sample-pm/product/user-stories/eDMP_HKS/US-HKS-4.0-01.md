## US-HKS-4.0-01 — Practice software must produce eHKS documents as valid CDA levelone XML

| Field | Value |
|-------|-------|
| **ID** | US-HKS-4.0-01 |
| **Traced from** | [HKS-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-4.0-01.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to produce eHKS documentation as valid CDA levelone XML documents, so that the documents conform to the HL7 CDA standard and can be processed by receiving systems.

### Acceptance Criteria

1. Given an eHKS documentation is created, when the XML is generated, then it is a valid CDA levelone document
2. Given a document missing required CDA levelone elements, when validated, then a schema error is reported

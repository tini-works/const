## US-KHK-4.0-01 — When practice software generates eDMP KHK XML, it must use CDA levelone document structure

| Field | Value |
|-------|-------|
| **ID** | US-KHK-4.0-01 |
| **Traced from** | [KHK-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-4.0-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate eDMP KHK documentation using CDA levelone document structure, so that the XML output conforms to the required clinical document architecture.

### Acceptance Criteria

1. Given an eDMP KHK documentation is exported, when the XML is generated, then the root element conforms to CDA levelone structure
2. Given a generated XML, when validated against the CDA levelone schema, then no schema violations are reported

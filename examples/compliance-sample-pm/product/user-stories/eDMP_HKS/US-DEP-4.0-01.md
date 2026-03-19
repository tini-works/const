## US-DEP-4.0-01 — When practice software generates eDMP Depression XML, it must use CDA levelone document structure

| Field | Value |
|-------|-------|
| **ID** | US-DEP-4.0-01 |
| **Traced from** | [DEP-4.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-4.0-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate eDMP Depression documentation using CDA levelone document structure, so that the XML output conforms to the required clinical document architecture.

### Acceptance Criteria

1. Given an eDMP Depression documentation is exported, when the XML is generated, then the root element conforms to CDA levelone structure
2. Given a generated XML, when validated against the CDA levelone schema, then no schema violations are reported

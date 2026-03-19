## HI-4.0-01 — When practice software generates eDMP HI XML, it must use CDA levelone document structure

| Field | Value |
|-------|-------|
| **ID** | HI-4.0-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 4 — Dokumentenstruktur |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-HI-4.0-01](../../../../../user-stories/eDMP_HKS/US-HI-4.0-01.md) |

### Requirement

When practice software generates eDMP HI XML, it must use CDA levelone document structure

### Acceptance Criteria

1. Given an eDMP HI documentation is exported, when the XML is generated, then the root element conforms to CDA levelone structure
2. Given a generated XML, when validated against the CDA levelone schema, then no schema violations are reported

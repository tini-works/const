## DEP-6.1.8-01 — When a doctor documents eDMP Depression training, Depression-specific Schulung recommendation must be captured

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.8-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.8 — Schulung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-6.1.8-01](../../../../../user-stories/eDMP_HKS/US-DEP-6.1.8-01.md) |

### Requirement

When a doctor documents eDMP Depression training, Depression-specific Schulung recommendation must be captured

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Schulung section is displayed, then a Depression-specific training recommendation field is available
2. Given a recommendation is made, when the XML is generated, then the Schulung empfohlen value is encoded correctly

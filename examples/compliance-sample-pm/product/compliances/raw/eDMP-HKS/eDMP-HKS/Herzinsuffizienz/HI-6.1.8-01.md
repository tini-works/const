## HI-6.1.8-01 — When a doctor documents eDMP HI training, HI-Schulung empfohlen must be recorded

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.8-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.8 — Schulung (empfohlen) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.8-01](../../../../../user-stories/eDMP_HKS/US-HI-6.1.8-01.md) |

### Requirement

When a doctor documents eDMP HI training, HI-Schulung empfohlen must be recorded

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Schulung section is displayed, then an HI-Schulung empfohlen field is available
2. Given a recommendation is made, when the XML is generated, then the Schulung empfohlen value is encoded correctly

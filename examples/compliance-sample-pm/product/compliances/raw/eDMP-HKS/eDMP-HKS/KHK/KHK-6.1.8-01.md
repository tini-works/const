## KHK-6.1.8-01 — When a doctor documents eDMP KHK training, KHK-Schulung empfohlen must be recorded

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.8-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.8 — Schulung (empfohlen) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-6.1.8-01](../../../../../user-stories/eDMP_HKS/US-KHK-6.1.8-01.md) |

### Requirement

When a doctor documents eDMP KHK training, KHK-Schulung empfohlen must be recorded

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Schulung section is displayed, then a KHK-Schulung empfohlen field is available
2. Given a recommendation is made, when the XML is generated, then the Schulung empfohlen value is encoded correctly

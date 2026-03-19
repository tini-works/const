## KHK-6.1.3-01 — When practice software encodes eDMP KHK observations, Sciphox-SSU encoding must be used

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.3-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.3 — Sciphox-SSU Kodierung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-KHK-6.1.3-01](../../../../../user-stories/eDMP_HKS/US-KHK-6.1.3-01.md) |

### Requirement

When practice software encodes eDMP KHK observations, Sciphox-SSU encoding must be used

### Acceptance Criteria

1. Given clinical observation data for KHK, when encoded in the XML, then Sciphox-SSU element structure is used
2. Given an observation element, when validated, then it conforms to the Sciphox-SSU schema for the observation type

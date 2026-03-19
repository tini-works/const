## DEP-6.1.3-01 — When practice software encodes eDMP Depression observations, Sciphox-SSU encoding must be used

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.3-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.3 — Sciphox-SSU Kodierung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-DEP-6.1.3-01](../../../../user-stories/eDMP_HKS/US-DEP-6.1.3-01.md) |

### Requirement

When practice software encodes eDMP Depression observations, Sciphox-SSU encoding must be used

### Acceptance Criteria

1. Given clinical observation data for Depression, when encoded in the XML, then Sciphox-SSU element structure is used
2. Given an observation element, when validated, then it conforms to the Sciphox-SSU schema for the observation type

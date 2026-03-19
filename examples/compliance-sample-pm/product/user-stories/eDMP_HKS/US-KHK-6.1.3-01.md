## US-KHK-6.1.3-01 — When practice software encodes eDMP KHK observations, Sciphox-SSU encoding must be used

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.3-01 |
| **Traced from** | [KHK-6.1.3-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.3-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to encode eDMP KHK observation data using Sciphox-SSU observation encoding, so that clinical values are structured in the standardized Sciphox format.

### Acceptance Criteria

1. Given clinical observation data for KHK, when encoded in the XML, then Sciphox-SSU element structure is used
2. Given an observation element, when validated, then it conforms to the Sciphox-SSU schema for the observation type

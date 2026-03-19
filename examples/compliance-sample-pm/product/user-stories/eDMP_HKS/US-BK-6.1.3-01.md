## US-BK-6.1.3-01 — Practice software must encode eDMP Brustkrebs observations using Sciphox-SSU format

| Field | Value |
|-------|-------|
| **ID** | US-BK-6.1.3-01 |
| **Traced from** | [BK-6.1.3-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-6.1.3-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to encode all eDMP Brustkrebs clinical observations using the Sciphox-SSU observation format, so that the observation data is interoperable and conforms to the KBV Sciphox specification.

### Acceptance Criteria

1. Given a clinical observation is documented for Brustkrebs, when the XML is generated, then it uses the Sciphox-SSU encoding
2. Given an observation not encoded as Sciphox-SSU, when validated, then an error is reported

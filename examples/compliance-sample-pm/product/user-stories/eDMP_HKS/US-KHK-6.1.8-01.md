## US-KHK-6.1.8-01 — When a doctor documents eDMP KHK training, KHK-Schulung empfohlen must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.8-01 |
| **Traced from** | [KHK-6.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.8-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether a KHK-specific training (KHK-Schulung) is recommended, so that the patient education recommendation is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Schulung section is displayed, then a KHK-Schulung empfohlen field is available
2. Given a recommendation is made, when the XML is generated, then the Schulung empfohlen value is encoded correctly

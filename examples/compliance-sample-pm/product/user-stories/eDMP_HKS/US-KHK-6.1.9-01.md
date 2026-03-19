## US-KHK-6.1.9-01 — When a doctor documents eDMP KHK treatment plan, Dokumentationsintervall must be specified

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.9-01 |
| **Traced from** | [KHK-6.1.9-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.9-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to specify the Dokumentationsintervall in the KHK treatment plan section, so that the next documentation frequency is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Behandlungsplanung section is displayed, then a Dokumentationsintervall field is available
2. Given an interval is selected, when the XML is generated, then the Dokumentationsintervall value is encoded correctly

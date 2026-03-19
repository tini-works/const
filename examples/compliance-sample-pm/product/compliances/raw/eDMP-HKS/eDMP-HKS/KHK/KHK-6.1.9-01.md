## KHK-6.1.9-01 — When a doctor documents eDMP KHK treatment plan, Dokumentationsintervall must be specified

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.9-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung (Dokumentationsintervall) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-6.1.9-01](../../../../../user-stories/eDMP_HKS/US-KHK-6.1.9-01.md) |

### Requirement

When a doctor documents eDMP KHK treatment plan, Dokumentationsintervall must be specified

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Behandlungsplanung section is displayed, then a Dokumentationsintervall field is available
2. Given an interval is selected, when the XML is generated, then the Dokumentationsintervall value is encoded correctly

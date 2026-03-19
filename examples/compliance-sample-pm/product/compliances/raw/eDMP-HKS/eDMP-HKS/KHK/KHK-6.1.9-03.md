## KHK-6.1.9-03 — When a doctor documents eDMP KHK treatment plan, KHK-bezogene Ueberweisung must be recorded

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.9-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung (Ueberweisung) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-6.1.9-03](../../../../user-stories/eDMP_HKS/US-KHK-6.1.9-03.md) |

### Requirement

When a doctor documents eDMP KHK treatment plan, KHK-bezogene Ueberweisung must be recorded

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Behandlungsplanung section is displayed, then a KHK-bezogene Ueberweisung field is available
2. Given a referral is documented, when the XML is generated, then the Ueberweisung value is encoded correctly

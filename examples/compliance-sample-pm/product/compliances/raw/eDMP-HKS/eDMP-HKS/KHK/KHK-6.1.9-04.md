## KHK-6.1.9-04 — When a doctor documents eDMP KHK treatment plan, Empfehlung Tabakverzicht must be recorded

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.9-04 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung (Tabakverzicht) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-6.1.9-04](../../../../../user-stories/eDMP_HKS/US-KHK-6.1.9-04.md) |

### Requirement

When a doctor documents eDMP KHK treatment plan, Empfehlung Tabakverzicht must be recorded

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Behandlungsplanung section is displayed, then an Empfehlung Tabakverzicht field is available
2. Given a recommendation is documented, when the XML is generated, then the Tabakverzicht value is encoded correctly

## US-KHK-6.1.9-04 — When a doctor documents eDMP KHK treatment plan, Empfehlung Tabakverzicht must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.9-04 |
| **Traced from** | [KHK-6.1.9-04](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.9-04.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the recommendation for tobacco cessation (Empfehlung Tabakverzicht) in the KHK treatment plan section, so that smoking cessation advice is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Behandlungsplanung section is displayed, then an Empfehlung Tabakverzicht field is available
2. Given a recommendation is documented, when the XML is generated, then the Tabakverzicht value is encoded correctly

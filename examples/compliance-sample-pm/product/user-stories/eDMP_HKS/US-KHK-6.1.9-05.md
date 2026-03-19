## US-KHK-6.1.9-05 — When a doctor documents eDMP KHK treatment plan, Empfehlung koerperliches Training must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.9-05 |
| **Traced from** | [KHK-6.1.9-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.9-05.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the recommendation for physical training (Empfehlung koerperliches Training) in the KHK treatment plan section, so that exercise advice is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Behandlungsplanung section is displayed, then an Empfehlung koerperliches Training field is available
2. Given a recommendation is documented, when the XML is generated, then the koerperliches Training value is encoded correctly

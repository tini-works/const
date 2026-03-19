## US-KHK-6.1.9-02 — When a doctor documents eDMP KHK treatment plan, Informationsangebote must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.9-02 |
| **Traced from** | [KHK-6.1.9-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.9-02.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Informationsangebote in the KHK treatment plan section, so that patient information offerings are recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Behandlungsplanung section is displayed, then an Informationsangebote field is available
2. Given information offerings are documented, when the XML is generated, then the values are encoded correctly

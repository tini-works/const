## HI-6.1.9-02 — When a doctor documents eDMP HI treatment plan, Informationsangebote must be recorded

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.9-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung (Informationsangebote) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.9-02](../../../../user-stories/eDMP_HKS/US-HI-6.1.9-02.md) |

### Requirement

When a doctor documents eDMP HI treatment plan, Informationsangebote must be recorded

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Behandlungsplanung section is displayed, then an Informationsangebote field is available
2. Given information offerings are documented, when the XML is generated, then the values are encoded correctly

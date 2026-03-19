## DEP-6.1.9-02 — When a doctor documents eDMP Depression treatment plan, Informationsangebote must be recorded

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.9-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung (Informationsangebote) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-6.1.9-02](../../../../../user-stories/eDMP_HKS/US-DEP-6.1.9-02.md) |

### Requirement

When a doctor documents eDMP Depression treatment plan, Informationsangebote must be recorded

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Behandlungsplanung section is displayed, then an Informationsangebote field is available
2. Given information offerings are documented, when the XML is generated, then the values are encoded correctly

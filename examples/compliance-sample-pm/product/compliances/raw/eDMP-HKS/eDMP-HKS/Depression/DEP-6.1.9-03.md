## DEP-6.1.9-03 — When a doctor documents eDMP Depression treatment plan, Psychotherapie empfohlen/veranlasst must be recorded

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.9-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung (Psychotherapie) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-6.1.9-03](../../../../../user-stories/eDMP_HKS/US-DEP-6.1.9-03.md) |

### Requirement

When a doctor documents eDMP Depression treatment plan, Psychotherapie empfohlen/veranlasst must be recorded

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Behandlungsplanung section is displayed, then a Psychotherapie empfohlen/veranlasst field is available
2. Given a psychotherapy recommendation is made, when the XML is generated, then the value is encoded correctly

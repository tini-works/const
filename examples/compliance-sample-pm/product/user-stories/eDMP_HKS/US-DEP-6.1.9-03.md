## US-DEP-6.1.9-03 — When a doctor documents eDMP Depression treatment plan, Psychotherapie empfohlen/veranlasst must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.9-03 |
| **Traced from** | [DEP-6.1.9-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.9-03.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether Psychotherapie is empfohlen or veranlasst in the treatment plan, so that psychotherapy recommendations are tracked per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Behandlungsplanung section is displayed, then a Psychotherapie empfohlen/veranlasst field is available
2. Given a psychotherapy recommendation is made, when the XML is generated, then the value is encoded correctly

## US-DEP-6.1.5-03 — When a doctor documents eDMP Depression anamnesis, comorbidities must be documented

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.5-03 |
| **Traced from** | [DEP-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.5-03.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document comorbidities in the Depression anamnesis section, so that relevant Begleiterkrankungen are recorded per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the anamnesis section is displayed, then comorbidity fields are available
2. Given comorbidities are documented, when the XML is generated, then each comorbidity is encoded in the correct element

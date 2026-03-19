## DEP-6.1.5-03 — When a doctor documents eDMP Depression anamnesis, comorbidities must be documented

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.5-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten (Begleiterkrankungen) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-6.1.5-03](../../../../../user-stories/eDMP_HKS/US-DEP-6.1.5-03.md) |

### Requirement

When a doctor documents eDMP Depression anamnesis, comorbidities must be documented

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the anamnesis section is displayed, then comorbidity fields are available
2. Given comorbidities are documented, when the XML is generated, then each comorbidity is encoded in the correct element

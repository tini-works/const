## HI-6.1.5-04 — When a doctor documents eDMP HI anamnesis, HI-specific Begleiterkrankungen must be documented

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.5-04 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten (Begleiterkrankungen) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.5-04](../../../../user-stories/eDMP_HKS/US-HI-6.1.5-04.md) |

### Requirement

When a doctor documents eDMP HI anamnesis, HI-specific Begleiterkrankungen must be documented

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then HI-specific comorbidity fields are available
2. Given comorbidities are documented, when the XML is generated, then each Begleiterkrankung is encoded in the correct HI-specific element

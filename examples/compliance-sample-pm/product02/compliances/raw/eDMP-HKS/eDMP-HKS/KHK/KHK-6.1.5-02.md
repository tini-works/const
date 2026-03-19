## KHK-6.1.5-02 — When a doctor documents eDMP KHK anamnesis, KHK-specific Begleiterkrankungen must be documented

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.5-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten (Begleiterkrankungen) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-6.1.5-02](../../../../user-stories/eDMP_HKS/US-KHK-6.1.5-02.md) |

### Requirement

When a doctor documents eDMP KHK anamnesis, KHK-specific Begleiterkrankungen must be documented

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the anamnesis section is displayed, then KHK-specific comorbidity fields are available
2. Given comorbidities are documented, when the XML is generated, then each Begleiterkrankung is encoded in the correct KHK-specific element

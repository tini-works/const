## US-KHK-6.1.5-02 — When a doctor documents eDMP KHK anamnesis, KHK-specific Begleiterkrankungen must be documented

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.5-02 |
| **Traced from** | [KHK-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.5-02.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document KHK-specific comorbidities (Begleiterkrankungen) in the anamnesis section, so that relevant accompanying diseases are recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the anamnesis section is displayed, then KHK-specific comorbidity fields are available
2. Given comorbidities are documented, when the XML is generated, then each Begleiterkrankung is encoded in the correct KHK-specific element

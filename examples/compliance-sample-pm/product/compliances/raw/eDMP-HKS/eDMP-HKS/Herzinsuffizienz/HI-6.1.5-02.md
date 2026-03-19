## HI-6.1.5-02 — When a doctor documents eDMP HI anamnesis, NYHA classification must be captured

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.5-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten (NYHA) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.5-02](../../../../../user-stories/eDMP_HKS/US-HI-6.1.5-02.md) |

### Requirement

When a doctor documents eDMP HI anamnesis, NYHA classification must be captured

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then a NYHA classification field is available with options I through IV
2. Given a NYHA class is selected, when the XML is generated, then the classification value is encoded in the correct observation element

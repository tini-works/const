## DEP-6.1.5-02 — When a doctor documents eDMP Depression anamnesis, PHQ-9 severity assessment must be captured

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.5-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten (PHQ-9) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-6.1.5-02](../../../../user-stories/eDMP_HKS/US-DEP-6.1.5-02.md) |

### Requirement

When a doctor documents eDMP Depression anamnesis, PHQ-9 severity assessment must be captured

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the anamnesis section is displayed, then a PHQ-9 assessment field is available
2. Given the PHQ-9 score is entered, when the XML is generated, then the severity value is encoded in the correct observation element
3. Given the PHQ-9 score is outside the valid range (0-27), when validation is triggered, then an error is displayed

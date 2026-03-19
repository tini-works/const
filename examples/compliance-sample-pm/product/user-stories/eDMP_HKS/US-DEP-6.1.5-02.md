## US-DEP-6.1.5-02 — When a doctor documents eDMP Depression anamnesis, PHQ-9 severity assessment must be captured

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.5-02 |
| **Traced from** | [DEP-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.5-02.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the Depression severity assessment using the PHQ-9 instrument, so that the degree of depression is systematically recorded per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the anamnesis section is displayed, then a PHQ-9 assessment field is available
2. Given the PHQ-9 score is entered, when the XML is generated, then the severity value is encoded in the correct observation element
3. Given the PHQ-9 score is outside the valid range (0-27), when validation is triggered, then an error is displayed

## HI-6.1.5-03 — When a doctor documents eDMP HI anamnesis, ejection fraction data must be captured

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.5-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten (Ejektionsfraktion) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.5-03](../../../../user-stories/eDMP_HKS/US-HI-6.1.5-03.md) |

### Requirement

When a doctor documents eDMP HI anamnesis, ejection fraction data must be captured

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the anamnesis section is displayed, then an ejection fraction field is available
2. Given the ejection fraction value is entered, when the XML is generated, then the value is encoded in the correct observation element
3. Given the ejection fraction is outside the valid range, when validation is triggered, then an error is displayed

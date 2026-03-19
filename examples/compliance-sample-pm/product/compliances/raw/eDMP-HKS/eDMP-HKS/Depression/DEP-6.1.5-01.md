## DEP-6.1.5-01 — When a doctor documents eDMP Depression anamnesis, Koerpergroesse, Koerpergewicht, Raucher, and Blutdruck must be captured

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.5-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten (Vitalwerte) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-6.1.5-01](../../../../../user-stories/eDMP_HKS/US-DEP-6.1.5-01.md) |

### Requirement

When a doctor documents eDMP Depression anamnesis, Koerpergroesse, Koerpergewicht, Raucher, and Blutdruck must be captured

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the anamnesis section is displayed, then fields for Koerpergroesse, Koerpergewicht, Raucher, and Blutdruck are present
2. Given all four fields are completed, when the XML is generated, then each value is encoded in the correct Sciphox-SSU element
3. Given a required field is missing, when validation is triggered, then a warning is displayed

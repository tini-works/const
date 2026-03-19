## US-DEP-6.1.5-01 — When a doctor documents eDMP Depression anamnesis, Koerpergroesse, Koerpergewicht, Raucher, and Blutdruck must be captured

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.5-01 |
| **Traced from** | [DEP-6.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.5-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Koerpergroesse, Koerpergewicht, Raucher status, and Blutdruck in the Depression anamnesis section, so that the required vital parameters are captured per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the anamnesis section is displayed, then fields for Koerpergroesse, Koerpergewicht, Raucher, and Blutdruck are present
2. Given all four fields are completed, when the XML is generated, then each value is encoded in the correct Sciphox-SSU element
3. Given a required field is missing, when validation is triggered, then a warning is displayed

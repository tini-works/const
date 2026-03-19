## DEP-7.1-01 — When a doctor documents eDMP Depression follow-up, Depression-specific Verlauf fields must be captured

| Field | Value |
|-------|-------|
| **ID** | DEP-7.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 7 — Verlaufsdokumentation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-7.1-01](../../../../user-stories/eDMP_HKS/US-DEP-7.1-01.md) |

### Requirement

When a doctor documents eDMP Depression follow-up, Depression-specific Verlauf fields must be captured

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Verlauf section is displayed, then Depression-specific follow-up fields are available
2. Given follow-up data is entered, when the XML is generated, then the values are encoded in the correct Depression-specific elements

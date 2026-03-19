## HI-6.1.7-05 — When a doctor documents eDMP HI medication, sonstige HI-spezifische Medikation must be captured

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.7-05 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.7 — Medikamente (Sonstige) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.7-05](../../../../user-stories/eDMP_HKS/US-HI-6.1.7-05.md) |

### Requirement

When a doctor documents eDMP HI medication, sonstige HI-spezifische Medikation must be captured

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the medication section is displayed, then a field for sonstige HI-spezifische Medikation is available
2. Given medication data is entered, when the XML is generated, then the values are encoded correctly

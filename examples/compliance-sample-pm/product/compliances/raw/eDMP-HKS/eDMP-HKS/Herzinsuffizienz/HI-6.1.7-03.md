## HI-6.1.7-03 — When a doctor documents eDMP HI medication, Diuretika status must be captured

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.7-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.7 — Medikamente (Diuretika) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.7-03](../../../../../user-stories/eDMP_HKS/US-HI-6.1.7-03.md) |

### Requirement

When a doctor documents eDMP HI medication, Diuretika status must be captured

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the medication section is displayed, then a Diuretika field is available
2. Given a selection is made, when the XML is generated, then the Diuretika value is encoded correctly

## HI-6.1.7-02 — When a doctor documents eDMP HI medication, Betablocker status must be captured

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.7-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.7 — Medikamente (Betablocker) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.7-02](../../../../user-stories/eDMP_HKS/US-HI-6.1.7-02.md) |

### Requirement

When a doctor documents eDMP HI medication, Betablocker status must be captured

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the medication section is displayed, then a Betablocker field is available
2. Given a selection is made, when the XML is generated, then the Betablocker value is encoded correctly

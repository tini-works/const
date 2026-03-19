## HI-7.1-02 — When a doctor documents eDMP HI follow-up, empfohlene Schulung wahrgenommen must be captured

| Field | Value |
|-------|-------|
| **ID** | HI-7.1-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 7 — Verlaufsdokumentation (Schulung wahrgenommen) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-7.1-02](../../../../user-stories/eDMP_HKS/US-HI-7.1-02.md) |

### Requirement

When a doctor documents eDMP HI follow-up, empfohlene Schulung wahrgenommen must be captured

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Verlauf section is displayed, then a field for empfohlene Schulung wahrgenommen is available
2. Given a value is selected, when the XML is generated, then it is encoded correctly

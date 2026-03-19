## KHK-7.1-02 — When a doctor documents eDMP KHK follow-up, empfohlene Schulung wahrgenommen must be captured

| Field | Value |
|-------|-------|
| **ID** | KHK-7.1-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 7 — Verlaufsdokumentation (Schulung wahrgenommen) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-7.1-02](../../../../../user-stories/eDMP_HKS/US-KHK-7.1-02.md) |

### Requirement

When a doctor documents eDMP KHK follow-up, empfohlene Schulung wahrgenommen must be captured

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Verlauf section is displayed, then a field for empfohlene Schulung wahrgenommen is available
2. Given a value is selected, when the XML is generated, then it is encoded correctly

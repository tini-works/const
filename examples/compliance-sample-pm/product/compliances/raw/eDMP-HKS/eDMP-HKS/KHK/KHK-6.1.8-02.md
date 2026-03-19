## KHK-6.1.8-02 — When a doctor documents eDMP KHK training, Schulung vor Einschreibung wahrgenommen must be recorded

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.8-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.8 — Schulung (vor Einschreibung) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-6.1.8-02](../../../../../user-stories/eDMP_HKS/US-KHK-6.1.8-02.md) |

### Requirement

When a doctor documents eDMP KHK training, Schulung vor Einschreibung wahrgenommen must be recorded

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Schulung section is displayed, then a Schulung vor Einschreibung wahrgenommen field is available
2. Given a value is selected, when the XML is generated, then it is encoded correctly

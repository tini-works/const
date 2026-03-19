## US-KHK-7.1-02 — When a doctor documents eDMP KHK follow-up, empfohlene Schulung wahrgenommen must be captured

| Field | Value |
|-------|-------|
| **ID** | US-KHK-7.1-02 |
| **Traced from** | [KHK-7.1-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-7.1-02.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the recommended training was attended (empfohlene Schulung wahrgenommen) in the follow-up section, so that patient education compliance is tracked per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Verlauf section is displayed, then a field for empfohlene Schulung wahrgenommen is available
2. Given a value is selected, when the XML is generated, then it is encoded correctly

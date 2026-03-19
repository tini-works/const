## US-KHK-6.1.8-02 — When a doctor documents eDMP KHK training, Schulung vor Einschreibung wahrgenommen must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.8-02 |
| **Traced from** | [KHK-6.1.8-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.8-02.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the patient attended training before enrollment (Schulung vor Einschreibung wahrgenommen), so that prior education status is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Schulung section is displayed, then a Schulung vor Einschreibung wahrgenommen field is available
2. Given a value is selected, when the XML is generated, then it is encoded correctly

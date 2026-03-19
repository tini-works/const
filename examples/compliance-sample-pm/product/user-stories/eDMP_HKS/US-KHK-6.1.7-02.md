## US-KHK-6.1.7-02 — When a doctor documents eDMP KHK medication, Betablocker status must be captured

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.7-02 |
| **Traced from** | [KHK-6.1.7-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.7-02.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Betablocker medication status (Nein/Ja/Kontraindikation) in the KHK medication section, so that beta-blocker therapy is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the medication section is displayed, then a Betablocker field with options Nein, Ja, and Kontraindikation is available
2. Given a selection is made, when the XML is generated, then the Betablocker value is encoded correctly

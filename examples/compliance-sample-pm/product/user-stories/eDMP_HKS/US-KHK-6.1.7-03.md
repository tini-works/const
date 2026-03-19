## US-KHK-6.1.7-03 — When a doctor documents eDMP KHK medication, ACE-Hemmer status must be captured

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.7-03 |
| **Traced from** | [KHK-6.1.7-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.7-03.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document ACE-Hemmer medication status (Nein/Ja/Kontraindikation/ARB) in the KHK medication section, so that ACE inhibitor therapy is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the medication section is displayed, then an ACE-Hemmer field with options Nein, Ja, Kontraindikation, and ARB is available
2. Given a selection is made, when the XML is generated, then the ACE-Hemmer value is encoded correctly

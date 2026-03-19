## KHK-6.1.7-03 — When a doctor documents eDMP KHK medication, ACE-Hemmer status must be captured

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.7-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.7 — Medikamente (ACE-Hemmer) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-6.1.7-03](../../../../../user-stories/eDMP_HKS/US-KHK-6.1.7-03.md) |

### Requirement

When a doctor documents eDMP KHK medication, ACE-Hemmer status must be captured

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the medication section is displayed, then an ACE-Hemmer field with options Nein, Ja, Kontraindikation, and ARB is available
2. Given a selection is made, when the XML is generated, then the ACE-Hemmer value is encoded correctly

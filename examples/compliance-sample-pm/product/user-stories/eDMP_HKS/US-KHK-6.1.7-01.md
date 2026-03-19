## US-KHK-6.1.7-01 — When a doctor documents eDMP KHK medication, Thrombozytenaggregationshemmer status must be captured

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.7-01 |
| **Traced from** | [KHK-6.1.7-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.7-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Thrombozytenaggregationshemmer medication status (Nein/Ja/Kontraindikation/orale Antikoagulation) in the KHK medication section, so that antiplatelet therapy is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the medication section is displayed, then a Thrombozytenaggregationshemmer field with options Nein, Ja, Kontraindikation, and orale Antikoagulation is available
2. Given a selection is made, when the XML is generated, then the Thrombozytenaggregationshemmer value is encoded correctly

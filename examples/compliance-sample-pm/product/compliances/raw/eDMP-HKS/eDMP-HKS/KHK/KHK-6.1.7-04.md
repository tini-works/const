## KHK-6.1.7-04 — When a doctor documents eDMP KHK medication, HMG-CoA-Reduktase-Hemmer status must be captured

| Field | Value |
|-------|-------|
| **ID** | KHK-6.1.7-04 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 6.1.7 — Medikamente (HMG-CoA) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-6.1.7-04](../../../../../user-stories/eDMP_HKS/US-KHK-6.1.7-04.md) |

### Requirement

When a doctor documents eDMP KHK medication, HMG-CoA-Reduktase-Hemmer status must be captured

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the medication section is displayed, then an HMG-CoA-Reduktase-Hemmer field with options Nein, Ja, and Kontraindikation is available
2. Given a selection is made, when the XML is generated, then the HMG-CoA-Reduktase-Hemmer value is encoded correctly

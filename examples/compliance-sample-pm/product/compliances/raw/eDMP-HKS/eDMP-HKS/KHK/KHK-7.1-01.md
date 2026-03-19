## KHK-7.1-01 — When a doctor documents eDMP KHK follow-up, ungeplante stationaere Behandlung wegen KHK (Anzahl) must be captured

| Field | Value |
|-------|-------|
| **ID** | KHK-7.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Sec 7 — Verlaufsdokumentation (stationaere Behandlung) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-KHK-7.1-01](../../../../../user-stories/eDMP_HKS/US-KHK-7.1-01.md) |

### Requirement

When a doctor documents eDMP KHK follow-up, ungeplante stationaere Behandlung wegen KHK (Anzahl) must be captured

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Verlauf section is displayed, then a field for ungeplante stationaere Behandlung wegen KHK (Anzahl) is available
2. Given a count is entered, when the XML is generated, then the Anzahl value is encoded correctly
3. Given a non-numeric or negative value is entered, when validation is triggered, then an error is displayed

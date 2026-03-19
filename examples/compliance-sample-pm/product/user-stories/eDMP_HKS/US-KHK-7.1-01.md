## US-KHK-7.1-01 — When a doctor documents eDMP KHK follow-up, ungeplante stationaere Behandlung wegen KHK (Anzahl) must be captured

| Field | Value |
|-------|-------|
| **ID** | US-KHK-7.1-01 |
| **Traced from** | [KHK-7.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-7.1-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the number of unplanned inpatient treatments due to KHK (ungeplante stationaere Behandlung wegen KHK), so that acute hospitalization events are tracked per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Verlauf section is displayed, then a field for ungeplante stationaere Behandlung wegen KHK (Anzahl) is available
2. Given a count is entered, when the XML is generated, then the Anzahl value is encoded correctly
3. Given a non-numeric or negative value is entered, when validation is triggered, then an error is displayed

## HI-7.1-01 — When a doctor documents eDMP HI follow-up, ungeplante Akutbehandlung wegen HI (Anzahl) must be captured

| Field | Value |
|-------|-------|
| **ID** | HI-7.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 7 — Verlaufsdokumentation (Akutbehandlung) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-7.1-01](../../../../../user-stories/eDMP_HKS/US-HI-7.1-01.md) |

### Requirement

When a doctor documents eDMP HI follow-up, ungeplante Akutbehandlung wegen HI (Anzahl) must be captured

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Verlauf section is displayed, then a field for ungeplante Akutbehandlung wegen HI (Anzahl) is available
2. Given a count is entered, when the XML is generated, then the Anzahl value is encoded correctly
3. Given a non-numeric or negative value is entered, when validation is triggered, then an error is displayed

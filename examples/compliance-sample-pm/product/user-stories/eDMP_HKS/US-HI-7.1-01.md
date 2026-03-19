## US-HI-7.1-01 — When a doctor documents eDMP HI follow-up, ungeplante Akutbehandlung wegen HI (Anzahl) must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-7.1-01 |
| **Traced from** | [HI-7.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-7.1-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the number of unplanned acute treatments due to Herzinsuffizienz (ungeplante Akutbehandlung wegen HI), so that acute events are tracked per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Verlauf section is displayed, then a field for ungeplante Akutbehandlung wegen HI (Anzahl) is available
2. Given a count is entered, when the XML is generated, then the Anzahl value is encoded correctly
3. Given a non-numeric or negative value is entered, when validation is triggered, then an error is displayed

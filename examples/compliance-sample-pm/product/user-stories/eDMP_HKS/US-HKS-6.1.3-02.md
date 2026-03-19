## US-HKS-6.1.3-02 — Practice doctor must document Gleichzeitig Gesundheitsuntersuchung as Ja or Nein in HKS-A documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-6.1.3-02 |
| **Traced from** | [HKS-6.1.3-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-6.1.3-02.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether a Gesundheitsuntersuchung was performed simultaneously as Ja or Nein in HKS-A documents, so that concurrent general health check-up status is captured for billing and reporting.

### Acceptance Criteria

1. Given an HKS-A document is created, when Gleichzeitig Gesundheitsuntersuchung is recorded, then exactly one of Ja or Nein is selected
2. Given no value is selected, when validated, then an error is reported

## HKS-6.1.3-02 — Practice doctor must document Gleichzeitig Gesundheitsuntersuchung as Ja or Nein in HKS-A documents

| Field | Value |
|-------|-------|
| **ID** | HKS-6.1.3-02 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 6.1.3 -- HKS-A Gesundheitsuntersuchung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-6.1.3-02](../../../../../user-stories/eDMP_HKS/US-HKS-6.1.3-02.md) |

### Requirement

As a practice doctor, I want to document whether a Gesundheitsuntersuchung was performed simultaneously as Ja or Nein in HKS-A documents, so that concurrent general health check-up status is captured for billing and reporting.

### Acceptance Criteria

1. Given an HKS-A document is created, when Gleichzeitig Gesundheitsuntersuchung is recorded, then exactly one of Ja or Nein is selected
2. Given no value is selected, when validated, then an error is reported

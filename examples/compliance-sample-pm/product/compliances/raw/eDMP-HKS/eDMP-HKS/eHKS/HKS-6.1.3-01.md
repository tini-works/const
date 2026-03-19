## HKS-6.1.3-01 — Practice doctor must document Gesamtbeurteilung Haut auffaellig as Ja or Nein in HKS-A documents

| Field | Value |
|-------|-------|
| **ID** | HKS-6.1.3-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 6.1.3 -- HKS-A Gesamtbeurteilung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-6.1.3-01](../../../../../user-stories/eDMP_HKS/US-HKS-6.1.3-01.md) |

### Requirement

As a practice doctor, I want to document Gesamtbeurteilung Haut auffaellig as Ja or Nein in HKS-A documents, so that the overall skin assessment result is captured for the general practitioner screening.

### Acceptance Criteria

1. Given an HKS-A document is created, when Gesamtbeurteilung Haut auffaellig is recorded, then exactly one of Ja or Nein is selected
2. Given no value is selected, when validated, then an error is reported

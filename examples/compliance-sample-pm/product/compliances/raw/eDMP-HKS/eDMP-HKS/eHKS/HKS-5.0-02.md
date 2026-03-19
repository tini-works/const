## HKS-5.0-02 — Practice software must include Gender field supporting maennlich, weiblich, unbestimmt, and divers per PStG in the eHKS header

| Field | Value |
|-------|-------|
| **ID** | HKS-5.0-02 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 5 -- Header (Alter) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-HKS-5.0-02](../../../../../user-stories/eDMP_HKS/US-HKS-5.0-02.md) |

### Requirement

As a practice software, I want to include the Gender field in the eHKS header supporting maennlich, weiblich, unbestimmt, and divers as defined by the Personenstandsgesetz (PStG), so that all legally recognized gender options are available in the document header.

### Acceptance Criteria

1. Given an eHKS document is created, when the header Gender field is recorded, then exactly one of maennlich, weiblich, unbestimmt, or divers is selected
2. Given no Gender value is selected, when validated, then an error is reported

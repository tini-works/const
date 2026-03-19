## US-HKS-5.0-02 — Practice software must include Gender field supporting maennlich, weiblich, unbestimmt, and divers per PStG in the eHKS header

| Field | Value |
|-------|-------|
| **ID** | US-HKS-5.0-02 |
| **Traced from** | [HKS-5.0-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-5.0-02.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to include the Gender field in the eHKS header supporting maennlich, weiblich, unbestimmt, and divers as defined by the Personenstandsgesetz (PStG), so that all legally recognized gender options are available in the document header.

### Acceptance Criteria

1. Given an eHKS document is created, when the header Gender field is recorded, then exactly one of maennlich, weiblich, unbestimmt, or divers is selected
2. Given no Gender value is selected, when validated, then an error is reported

## COPD-6.1.4-01 — Administrative data field "Einschreibung wegen" must contain "COPD"

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.4-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.4 — Administrative Daten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.4-01](../../../../../user-stories/eDMP_HKS/US-COPD-6.1.4-01.md) |

### Requirement

As a practice software, I want the administrative data field "Einschreibung wegen" to be automatically set to "COPD" in eDMP COPD documentation, so that the enrollment reason is correctly recorded.

### Acceptance Criteria

1. Given an eDMP COPD document is created, when the administrative section is generated, then "Einschreibung wegen" contains "COPD"
2. Given any other value in "Einschreibung wegen", when validated, then an error is raised

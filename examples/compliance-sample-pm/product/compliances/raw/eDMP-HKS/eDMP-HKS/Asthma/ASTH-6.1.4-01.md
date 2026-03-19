## ASTH-6.1.4-01 — Administrative data field "Einschreibung wegen" must contain "Asthma bronchiale"

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.4-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.4 — Administrative Daten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.4-01](../../../../../user-stories/eDMP_HKS/US-ASTH-6.1.4-01.md) |

### Requirement

As a practice software, I want the administrative data field "Einschreibung wegen" to be automatically set to "Asthma bronchiale" in eDMP Asthma documentation, so that the enrollment reason is correctly recorded.

### Acceptance Criteria

1. Given an eDMP Asthma document is created, when the administrative section is generated, then "Einschreibung wegen" contains "Asthma bronchiale"
2. Given any other value in "Einschreibung wegen", when validated, then an error is raised

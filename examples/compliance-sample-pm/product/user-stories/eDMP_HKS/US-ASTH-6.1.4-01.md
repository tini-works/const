## US-ASTH-6.1.4-01 — Administrative data field "Einschreibung wegen" must contain "Asthma bronchiale"

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.4-01 |
| **Traced from** | [ASTH-6.1.4-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.4-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want the administrative data field "Einschreibung wegen" to be automatically set to "Asthma bronchiale" in eDMP Asthma documentation, so that the enrollment reason is correctly recorded.

### Acceptance Criteria

1. Given an eDMP Asthma document is created, when the administrative section is generated, then "Einschreibung wegen" contains "Asthma bronchiale"
2. Given any other value in "Einschreibung wegen", when validated, then an error is raised

## BK-7.1-01 — Practice doctor must document follow-up specific fields in the Verlauf section

| Field | Value |
|-------|-------|
| **ID** | BK-7.1-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 7 -- Verlaufsdokumentation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-BK-7.1-01](../../../../../user-stories/eDMP_HKS/US-BK-7.1-01.md) |

### Requirement

As a practice doctor, I want to document follow-up specific fields in the Verlauf section of the eDMP Brustkrebs documentation, so that breast cancer follow-up data is captured for long-term outcome monitoring.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Verlauf section is documented, when follow-up fields are recorded, then all required follow-up data points are stored
2. Given required follow-up fields are missing, when validated, then an error is reported

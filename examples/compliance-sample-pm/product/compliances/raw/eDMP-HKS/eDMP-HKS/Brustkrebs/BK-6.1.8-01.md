## BK-6.1.8-01 — Practice doctor must document Schulung and Behandlungsplanung in the eDMP Brustkrebs documentation

| Field | Value |
|-------|-------|
| **ID** | BK-6.1.8-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 6.1.8 -- Schulung/Behandlungsplanung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-BK-6.1.8-01](../../../../../user-stories/eDMP_HKS/US-BK-6.1.8-01.md) |

### Requirement

As a practice doctor, I want to document Schulung and Behandlungsplanung fields in the eDMP Brustkrebs documentation, so that patient education and treatment planning are captured for comprehensive breast cancer care.

### Acceptance Criteria

1. Given an eDMP Brustkrebs documentation is created, when the Schulung/Behandlungsplanung section is filled, then the required education and planning fields are recorded
2. Given required Schulung/Behandlungsplanung fields are missing, when validated, then an error is reported

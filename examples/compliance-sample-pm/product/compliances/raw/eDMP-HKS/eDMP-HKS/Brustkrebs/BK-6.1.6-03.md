## BK-6.1.6-03 — Practice doctor must document Chemotherapie status in the Behandlung section

| Field | Value |
|-------|-------|
| **ID** | BK-6.1.6-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 6.1.6 -- Behandlung (Chemotherapie) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-BK-6.1.6-03](../../../../user-stories/eDMP_HKS/US-BK-6.1.6-03.md) |

### Requirement

As a practice doctor, I want to document Chemotherapie status in the Behandlung section of the eDMP Brustkrebs documentation, so that chemotherapy treatment status is captured for multimodal treatment tracking.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Behandlung section is documented, when Chemotherapie is recorded, then the chemotherapy status is stored
2. Given the Chemotherapie field is missing, when validated, then an error is reported

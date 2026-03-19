## BK-6.1.6-05 — Practice doctor must document Nebenwirkungen endokrine Therapie in the Behandlung section

| Field | Value |
|-------|-------|
| **ID** | BK-6.1.6-05 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 6.1.6 -- Behandlung (Nebenwirkungen) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-BK-6.1.6-05](../../../../user-stories/eDMP_HKS/US-BK-6.1.6-05.md) |

### Requirement

As a practice doctor, I want to document Nebenwirkungen (side effects) of endocrine therapy in the Behandlung section, so that side effects of endocrine therapy are tracked for therapy adherence and adjustment.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Behandlung section is documented and endokrine Therapie is active, when Nebenwirkungen is recorded, then the side effect information is stored
2. Given endokrine Therapie is active but Nebenwirkungen field is missing, when validated, then an error is reported

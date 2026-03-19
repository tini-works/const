## US-BK-6.1.6-01 — Practice doctor must document Operative Therapie in the Behandlung section

| Field | Value |
|-------|-------|
| **ID** | US-BK-6.1.6-01 |
| **Traced from** | [BK-6.1.6-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-6.1.6-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Operative Therapie details in the Behandlung section of the eDMP Brustkrebs documentation, so that surgical treatment history is captured for treatment tracking.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Behandlung section is documented, when Operative Therapie is recorded, then the surgical intervention details are stored
2. Given the Operative Therapie field is missing, when validated, then an error is reported

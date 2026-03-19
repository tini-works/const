## BK-P-02 — Practice software must validate eDMP Brustkrebs documents against EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules

| Field | Value |
|-------|-------|
| **ID** | BK-P-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Plausibility BK-specific |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | Pruefmodul validation |
| **Matched by** | [US-BK-P-02](../../../../../user-stories/eDMP_HKS/US-BK-P-02.md) |

### Requirement

As a practice software, I want to validate all eDMP Brustkrebs documents against the EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend cross-programme plausibility rule set, so that cross-programme plausibility errors are detected and reported before submission.

### Acceptance Criteria

1. Given an eDMP Brustkrebs document is completed, when plausibility validation is run, then all EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules are evaluated
2. Given a cross-programme plausibility rule is violated, when validation completes, then the specific rule violation and affected field are reported to the user

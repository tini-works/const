## US-BK-P-02 — Practice software must validate eDMP Brustkrebs documents against EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules

| Field | Value |
|-------|-------|
| **ID** | US-BK-P-02 |
| **Traced from** | [BK-P-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-P-02.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eDMP Brustkrebs documents against the EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend cross-programme plausibility rule set, so that cross-programme plausibility errors are detected and reported before submission.

### Acceptance Criteria

1. Given an eDMP Brustkrebs document is completed, when plausibility validation is run, then all EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules are evaluated
2. Given a cross-programme plausibility rule is violated, when validation completes, then the specific rule violation and affected field are reported to the user

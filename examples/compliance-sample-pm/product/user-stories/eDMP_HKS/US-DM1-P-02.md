## US-DM1-P-02 — Practice software must validate eDMP DM1 documents against EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules

| Field | Value |
|-------|-------|
| **ID** | US-DM1-P-02 |
| **Traced from** | [DM1-P-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-P-02.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eDMP DM1 documents against the EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend cross-programme plausibility rule set, so that cross-programme plausibility errors are detected and reported before submission.

### Acceptance Criteria

1. Given an eDMP DM1 document is completed, when plausibility validation is run, then all EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules are evaluated
2. Given a cross-programme plausibility rule is violated, when validation completes, then the specific rule violation and affected field are reported to the user

## US-DM2-P-01 — Practice software must validate eDMP DM2 documents against EXT_ITA_VGEX_Plausi_eDMP_DM1_DM2 rules

| Field | Value |
|-------|-------|
| **ID** | US-DM2-P-01 |
| **Traced from** | [DM2-P-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-P-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eDMP DM2 documents against the EXT_ITA_VGEX_Plausi_eDMP_DM1_DM2 plausibility rule set before transmission, so that DM1/DM2-specific plausibility errors are detected and reported before submission.

### Acceptance Criteria

1. Given an eDMP DM2 document is completed, when plausibility validation is run, then all EXT_ITA_VGEX_Plausi_eDMP_DM1_DM2 rules are evaluated
2. Given a plausibility rule is violated, when validation completes, then the specific rule violation and affected field are reported to the user

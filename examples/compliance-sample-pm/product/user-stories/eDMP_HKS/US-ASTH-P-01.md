## US-ASTH-P-01 — Practice software must validate eDMP Asthma data against EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-P-01 |
| **Traced from** | [ASTH-P-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-P-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eDMP Asthma documentation data against the cross-program plausibility rules defined in EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend, so that general eDMP plausibility requirements are met before transmission.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is completed, when validation is triggered, then all rules from EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend are applied
2. Given a plausibility rule is violated, when validation runs, then the specific rule violation and affected field are reported to the user
3. Given all cross-program rules pass, when validation completes, then the document is cleared for Asthma-specific validation

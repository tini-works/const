## US-COPD-P-02 — Practice software must validate eDMP COPD data against EXT_ITA_VGEX_Plausi_eDMP_COPD

| Field | Value |
|-------|-------|
| **ID** | US-COPD-P-02 |
| **Traced from** | [COPD-P-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-P-02.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eDMP COPD documentation data against the COPD-specific plausibility rules defined in EXT_ITA_VGEX_Plausi_eDMP_COPD, so that COPD-specific data consistency is ensured before transmission.

### Acceptance Criteria

1. Given an eDMP COPD documentation is completed, when validation is triggered, then all rules from EXT_ITA_VGEX_Plausi_eDMP_COPD are applied
2. Given a COPD-specific plausibility rule is violated, when validation runs, then the specific rule violation and affected field are reported to the user
3. Given all COPD-specific rules pass, when validation completes, then the document is cleared for export

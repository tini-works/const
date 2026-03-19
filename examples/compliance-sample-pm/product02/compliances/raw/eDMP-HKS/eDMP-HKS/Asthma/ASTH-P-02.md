## ASTH-P-02 — Practice software must validate eDMP Asthma data against EXT_ITA_VGEX_Plausi_eDMP_Asthma

| Field | Value |
|-------|-------|
| **ID** | ASTH-P-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Plausibilitaetspruefungen — Asthma-spezifisch |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | Pruefmodul validation |
| **Matched by** | [US-ASTH-P-02](../../../../user-stories/eDMP_HKS/US-ASTH-P-02.md) |

### Requirement

As a practice software, I want to validate all eDMP Asthma documentation data against the Asthma-specific plausibility rules defined in EXT_ITA_VGEX_Plausi_eDMP_Asthma, so that Asthma-specific data consistency is ensured before transmission.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is completed, when validation is triggered, then all rules from EXT_ITA_VGEX_Plausi_eDMP_Asthma are applied
2. Given an Asthma-specific plausibility rule is violated, when validation runs, then the specific rule violation and affected field are reported to the user
3. Given all Asthma-specific rules pass, when validation completes, then the document is cleared for export

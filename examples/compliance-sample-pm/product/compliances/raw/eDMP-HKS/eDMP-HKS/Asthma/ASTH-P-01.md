## ASTH-P-01 — Practice software must validate eDMP Asthma data against EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend

| Field | Value |
|-------|-------|
| **ID** | ASTH-P-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Plausibilitaetspruefungen — uebergreifend |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | Pruefmodul validation |
| **Matched by** | [US-ASTH-P-01](../../../../user-stories/eDMP_HKS/US-ASTH-P-01.md) |

### Requirement

As a practice software, I want to validate all eDMP Asthma documentation data against the cross-program plausibility rules defined in EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend, so that general eDMP plausibility requirements are met before transmission.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is completed, when validation is triggered, then all rules from EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend are applied
2. Given a plausibility rule is violated, when validation runs, then the specific rule violation and affected field are reported to the user
3. Given all cross-program rules pass, when validation completes, then the document is cleared for Asthma-specific validation

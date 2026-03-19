## HKS-P-01 — Practice software must validate eHKS documents against EXT_ITA_VGEX_Plausi_eHKS rules

| Field | Value |
|-------|-------|
| **ID** | HKS-P-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Plausibility eHKS |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | Pruefmodul validation |
| **Matched by** | [US-HKS-P-01](../../../../../user-stories/eDMP_HKS/US-HKS-P-01.md) |

### Requirement

As a practice software, I want to validate all eHKS documents against the EXT_ITA_VGEX_Plausi_eHKS plausibility rule set before transmission, so that eHKS-specific plausibility errors are detected and reported before submission.

### Acceptance Criteria

1. Given an eHKS document is completed, when plausibility validation is run, then all EXT_ITA_VGEX_Plausi_eHKS rules are evaluated
2. Given a plausibility rule is violated, when validation completes, then the specific rule violation and affected field are reported to the user

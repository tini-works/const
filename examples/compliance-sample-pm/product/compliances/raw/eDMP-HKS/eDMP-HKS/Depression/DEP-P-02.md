## DEP-P-02 — When practice software validates eDMP Depression data, Depression-specific plausibility rules must be applied

| Field | Value |
|-------|-------|
| **ID** | DEP-P-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Plausibilitaetspruefung (Depression-spezifisch) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | Pruefmodul validation |
| **Matched by** | [US-DEP-P-02](../../../../../user-stories/eDMP_HKS/US-DEP-P-02.md) |

### Requirement

When practice software validates eDMP Depression data, Depression-specific plausibility rules must be applied

### Acceptance Criteria

1. Given an eDMP Depression documentation is complete, when plausibility validation is triggered, then all EXT_ITA_VGEX_Plausi_eDMP_Depression rules are evaluated
2. Given a Depression-specific plausibility rule is violated, when validation completes, then the specific violation is displayed to the user

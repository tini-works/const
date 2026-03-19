## KHK-P-02 — When practice software validates eDMP KHK data, KHK-specific plausibility rules must be applied

| Field | Value |
|-------|-------|
| **ID** | KHK-P-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Section** | Plausibilitaetspruefung (KHK-spezifisch) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | Pruefmodul validation |
| **Matched by** | [US-KHK-P-02](../../../../user-stories/eDMP_HKS/US-KHK-P-02.md) |

### Requirement

When practice software validates eDMP KHK data, KHK-specific plausibility rules must be applied

### Acceptance Criteria

1. Given an eDMP KHK documentation is complete, when plausibility validation is triggered, then all EXT_ITA_VGEX_Plausi_eDMP_KHK rules are evaluated
2. Given a KHK-specific plausibility rule is violated, when validation completes, then the specific violation is displayed to the user

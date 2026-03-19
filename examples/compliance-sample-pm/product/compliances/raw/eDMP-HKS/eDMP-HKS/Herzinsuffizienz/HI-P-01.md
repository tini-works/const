## HI-P-01 — When practice software validates eDMP HI data, cross-module plausibility rules (Uebergreifend) must be applied

| Field | Value |
|-------|-------|
| **ID** | HI-P-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Plausibilitaetspruefung (uebergreifend) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | Pruefmodul validation |
| **Matched by** | [US-HI-P-01](../../../../../user-stories/eDMP_HKS/US-HI-P-01.md) |

### Requirement

When practice software validates eDMP HI data, cross-module plausibility rules (Uebergreifend) must be applied

### Acceptance Criteria

1. Given an eDMP HI documentation is complete, when plausibility validation is triggered, then all EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules are evaluated
2. Given a cross-module plausibility rule is violated, when validation completes, then the specific violation is displayed to the user

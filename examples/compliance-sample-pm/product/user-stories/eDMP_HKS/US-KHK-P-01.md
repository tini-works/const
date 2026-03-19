## US-KHK-P-01 — When practice software validates eDMP KHK data, cross-module plausibility rules (Uebergreifend) must be applied

| Field | Value |
|-------|-------|
| **ID** | US-KHK-P-01 |
| **Traced from** | [KHK-P-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-P-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to apply the EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend plausibility rules when validating KHK documentation, so that cross-module consistency checks are enforced before transmission.

### Acceptance Criteria

1. Given an eDMP KHK documentation is complete, when plausibility validation is triggered, then all EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules are evaluated
2. Given a cross-module plausibility rule is violated, when validation completes, then the specific violation is displayed to the user

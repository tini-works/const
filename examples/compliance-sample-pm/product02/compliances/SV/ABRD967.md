## ABRD967 — Multimorbidity check must be available in the diagnosis module for...

| Field | Value |
|-------|-------|
| **ID** | ABRD967 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD967](../../user-stories/US-ABRD967.md) |

### Requirement

Multimorbidity check must be available in the diagnosis module for individual patients

### Acceptance Criteria

1. Given a Patient with documented Diagnosen, when Multimorbidity check is triggered, then patients with 3+ Krankheitsbilder are flagged

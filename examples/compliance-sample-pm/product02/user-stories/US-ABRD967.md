## US-ABRD967 — Multimorbidity check must be available in the diagnosis module for...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD967 |
| **Traced from** | [ABRD967](../compliances/SV/ABRD967.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want multimorbidity check is available in the diagnosis module for individual patients, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Patient with documented Diagnosen, when Multimorbidity check is triggered, then patients with 3+ Krankheitsbilder are flagged

### Actual Acceptance Criteria

1. Implemented -- `billing.AnalyzeForP4Diseases` returns DiseaseGroups per patient for multimorbidity.
2. `billing.CalculateBillingSummary` aggregates disease group counts.

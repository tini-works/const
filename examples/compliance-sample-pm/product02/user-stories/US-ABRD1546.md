## US-ABRD1546 — During billing validation, system must perform multimorbidity check identifying patients...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1546 |
| **Traced from** | [ABRD1546](../compliances/SV/ABRD1546.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want during billing validation, system perform multimorbidity check identifying patients with 3+ disease patterns, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given Abrechnungsvalidierung, when a patient has 3+ Krankheitsbilder, then the multimorbidity flag is set on the billing case

### Actual Acceptance Criteria

1. Implemented -- `billing.AnalyzeForP4Diseases` identifies 3+ disease groups; `billing.CalculateBillingSummary` calculates surcharge.

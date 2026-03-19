## US-ABRD1015 — The Vertragssoftware must sort and filter P4-relevant disease patterns: a...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1015 |
| **Traced from** | [ABRD1015](../compliances/SV/ABRD1015.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | DX, PAT |

### User Story

As a practice doctor, I want the Vertragssoftware sort and filter P4-relevant disease patterns: a dropdown to filter by count (0,1,2,3,4+) of documented P4-relevant Krankheitsbilder, plus an option to include P3 patterns documented in the current billing quarter, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given P4-relevant Krankheitsbilder documented, when the user opens the filter, then a dropdown with counts 0-4+ is available and a checkbox to include current-quarter P3 patterns is present
2. Given a filter selection, when applied, then only matching disease patterns are shown

### Actual Acceptance Criteria

1. Implemented (backend) -- `billing.AnalyzeForP4Diseases` provides data; UI filter is frontend concern.

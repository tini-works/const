## US-VSST545 — The Vertragssoftware must display HPM medication recommendation results in tabular...

| Field | Value |
|-------|-------|
| **ID** | US-VSST545 |
| **Traced from** | [VSST545](../compliances/SV/VSST545.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware display HPM medication recommendation results in tabular form classified by ATC groups, sorted ascending by priority from 0, with medications color-coded by category and all information from the result file shown, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given HPM medication recommendation results, when displayed, then they appear in a table grouped by ATC group sorted ascending by priority, with medications color-coded by category

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/hpm_check_history`, `api/medicine`

1. **HPM result handling** -- The `hpm_check_history` package exists for tracking HPM interactions.
2. **Gap: Tabular ATC-grouped display** -- The specific display of HPM medication recommendations in tabular form, grouped by ATC, sorted by priority, and color-coded by category is a frontend feature. The backend data structures for HPM results need verification for supporting this display format.

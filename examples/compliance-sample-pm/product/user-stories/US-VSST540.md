## US-VSST540 — In practice-level and patient-level medication lists and catalog searches, the...

| Field | Value |
|-------|-------|
| **ID** | US-VSST540 |
| **Traced from** | [VSST540](../compliances/SV/VSST540.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want in practice-level and patient-level medication lists and catalog searches, the Vertragssoftware not display prices for medications in category 'Gruen'; instead, the word 'rabattiert' is shown, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a medication of category Gruen, when displayed in practice/patient lists or search results, then 'rabattiert' is shown instead of the price

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/hpm_check_history`

1. **Medication display infrastructure** -- Same as VSST539. The `medicine` API provides medication lists.
2. **Gap: 'rabattiert' display for Gruen only** -- The specific UI logic to replace price with 'rabattiert' for Gruen category medications is a frontend/HPM feature not verified in the backend.

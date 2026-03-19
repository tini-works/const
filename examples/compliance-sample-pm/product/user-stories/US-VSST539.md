## US-VSST539 — In practice-level and patient-level medication lists and catalog searches, the...

| Field | Value |
|-------|-------|
| **ID** | US-VSST539 |
| **Traced from** | [VSST539](../compliances/SV/VSST539.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want in practice-level and patient-level medication lists and catalog searches, the Vertragssoftware not display prices for medications in categories 'Gruen' and 'Blau'; instead, the word 'rabattiert' is shown. Individual categories may be absent per contract, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a medication of category Gruen or Blau, when displayed in practice/patient lists or search results, then 'rabattiert' is shown instead of the price

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/hpm_check_history`

1. **Medication display infrastructure** -- The `medicine` API provides medication search and list display. Price handling exists in the data model.
2. **Gap: 'rabattiert' display for Gruen/Blau** -- The specific UI logic to replace price with 'rabattiert' for medications in categories 'Gruen' and 'Blau' in practice-level and patient-level lists is a frontend/HPM integration feature. The HPM integration for category-based price suppression is not verified in the backend.

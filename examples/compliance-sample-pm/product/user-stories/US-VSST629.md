## US-VSST629 — When prescribing a steuerbare Hilfsmittel, the Vertragssoftware must check whether...

| Field | Value |
|-------|-------|
| **ID** | US-VSST629 |
| **Traced from** | [VSST629](../compliances/SV/VSST629.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, FRM |

### User Story

As a practice staff, I want when prescribing a steuerbare Hilfsmittel, the Vertragssoftware check whether a questionnaire (Fragebogen) is required by verifying whether the FRAGEBOGEN column in the steuerbare Hilfsmittel list is non-empty, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a steuerbare Hilfsmittel, when its FRAGEBOGEN column is non-empty, then the system requires the user to fill out the questionnaire

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/himi`

1. **Steuerbare HIMI data** -- The `SearchControllableHimi` returns controllable Hilfsmittel data including metadata fields.
2. **Gap: FRAGEBOGEN column check** -- The specific check of the FRAGEBOGEN column non-emptiness to determine questionnaire requirement needs verification in the steuerbare Hilfsmittel data model.

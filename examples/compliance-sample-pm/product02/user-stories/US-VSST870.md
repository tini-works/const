## US-VSST870 — The Vertragssoftware must automatically and immediately display insurance-specific medication categories...

| Field | Value |
|-------|-------|
| **ID** | US-VSST870 |
| **Traced from** | [VSST870](../compliances/SV/VSST870.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware automatically and immediately display insurance-specific medication categories and recommendations to the user without requiring user interaction first, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given insurance-specific medication data, when available, then categories and recommendations are displayed automatically and immediately without requiring user interaction

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/hpm_check_history`

1. **Medication display** -- The `medicine` API provides medication data.
2. **Gap: Automatic display without user interaction** -- The specific requirement that insurance-specific medication categories and recommendations display automatically and immediately without requiring user interaction is a UI/frontend requirement not verified in the backend.

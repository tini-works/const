## US-VSST599 — When issuing an AU or eAU, the Vertragssoftware must display...

| Field | Value |
|-------|-------|
| **ID** | US-VSST599 |
| **Traced from** | [VSST599](../compliances/SV/VSST599.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want when issuing an AU or eAU, the Vertragssoftware display a hint if employment data is empty or older than 1 year, requesting the user to fill in employment status before issuing the AU, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given empty or outdated (>1 year) employment data, when an AU or eAU is issued, then a hint requests the user to fill in employment data before issuing

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/eau`, `api/patient_profile`

1. **eAU creation** -- The `eau` package provides eAU creation with form data.
2. **Gap: Employment data validation hint** -- The specific hint display when employment data is empty or older than 1 year during AU/eAU issuance is not verified in the backend. This requires date comparison logic against 'Datum letzte Ueberpruefung'.

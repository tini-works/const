## US-VSST854 — The Pruef- und Abrechnungsmodul returns Priscus-Liste markings for insurance-specific medication...

| Field | Value |
|-------|-------|
| **ID** | US-VSST854 |
| **Traced from** | [VSST854](../compliances/SV/VSST854.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Pruef- und Abrechnungsmodul returns Priscus-Liste markings for insurance-specific medication recommendations, which is displayed to the user in column form, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given insurance-specific medication recommendations, when displayed, then a Priscus-Liste column is shown for each medication

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/hpm_check_history`, `api/medicine`

1. **HPM integration** -- The `hpm_check_history` package exists for HPM interaction tracking.
2. **Gap: Priscus-Liste column in recommendations** -- The specific display of Priscus-Liste markings as a column in insurance-specific medication recommendations from the Pruef- und Abrechnungsmodul is not verified.

## US-VSST537 — Insurance-specific drug categories must be displayed

| Field | Value |
|-------|-------|
| **ID** | US-VSST537 |
| **Traced from** | [VSST537](../compliances/SV/VSST537.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want insurance-specific drug categories is displayed, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Verordnung for a specific Kasse, when drug selection is shown, then insurance-specific Arzneimittelkategorien are displayed

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/medicine_kbv`, `api/hpm_check_history`

1. **Medication catalog with categories** -- The `medicine` API provides drug search and display. The `medicine_kbv` package includes KBV-specific medication data.
2. **Gap: Insurance-specific Arzneimittelkategorien display** -- The HPM-based insurance-specific medication categories (Gruen, Blau, Rot, Orange) require HPM integration. The HPM check history package exists (`hpm_check_history`), but the specific display of insurance-specific categories per Kasse needs verification.

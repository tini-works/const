## US-VSST543 — The HPM endpoints for medication information, substitutions, and lists must...

| Field | Value |
|-------|-------|
| **ID** | US-VSST543 |
| **Traced from** | [VSST543](../compliances/SV/VSST543.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the HPM endpoints for medication information, substitutions, and lists is queried via HTTP POST using the patient's Hauptkassen-IK derived from the Kostentraegerdaten of the Selektivvertragsdefinition, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a medication query to HPM endpoints, when the query is executed, then it uses HTTP POST with the Hauptkassen-IK derived from the Selektivvertragsdefinition Kostentraegerdaten

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/hpm_check_history`, `api/contract`

1. **HPM endpoint infrastructure** -- The system has HPM integration capabilities via the `hpm_check_history` package and external service infrastructure.
2. **Contract data access** -- The `contract` package provides Selektivvertragsdefinition data including Kostentraegerdaten for Hauptkassen-IK derivation.
3. **Gap: HTTP POST with Hauptkassen-IK** -- The specific implementation of HPM medication endpoint queries using HTTP POST with the derived Hauptkassen-IK needs verification.

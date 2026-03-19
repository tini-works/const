## US-VSST1547 — The following DMPs must be integrated per KBV specifications: eDMP...

| Field | Value |
|-------|-------|
| **ID** | US-VSST1547 |
| **Traced from** | [VSST1547](../compliances/SV/VSST1547.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | PVS, PAT |

### User Story

As a practice staff, I want the following DMPs is integrated per KBV specifications: eDMP Diabetes Mellitus Type 1 and Type 2, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the Vertragssoftware, when DMP functionality is accessed, then eDMP Diabetes Mellitus Type 1 and Type 2 are available per KBV specifications

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/edmp`, `api/edoku`

1. **eDMP Diabetes modules** -- The `edmp` package supports DMP Diabetes Mellitus Type 1 and Type 2 via `DMPLabelingValue`. The full documentation workflow (Enroll, CreateDocument, Save/Finish DocumentationOverview, CheckPlausibility) applies to Diabetes DMPs.
2. **KBV compliance** -- The eDMP system generates KBV-compliant documentation with plausibility checks.

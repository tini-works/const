## US-VSST1574 — VERAH TopVersorgt list

| Field | Value |
|-------|-------|
| **ID** | US-VSST1574 |
| **Traced from** | [VSST1574](../compliances/SV/VSST1574.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | PAT, VTG |

### User Story

As a practice staff, I want vERAH TopVersorgt list, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given VERAH TopVersorgt patients, when the list is opened, then all eligible patients are shown with status

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/patient_search`, `api/patient_overview`

1. **Patient lists** -- The `patient_search` and `patient_overview` packages provide patient listing capabilities.
2. **Gap: VERAH TopVersorgt patient list** -- A dedicated list showing all VERAH TopVersorgt eligible patients with status is not verified in the codebase.

## US-VSST538 — Contract-specific prescription data requirements (details truncated in source)

| Field | Value |
|-------|-------|
| **ID** | US-VSST538 |
| **Traced from** | [VSST538](../compliances/SV/VSST538.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, VTG |

### User Story

As a practice staff, I want contract-specific prescription data requirements (details truncated in source), so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given contract-specific prescription data requirements, when Verordnungsdaten are processed, then the requirements are enforced

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/contract`, `api/enrollment`, `api/patient_participation`, `api/medicine`

1. **Contract-specific data handling** -- The `contract` API package manages Selektivvertragsdefinition data. The `enrollment` and `patient_participation` packages handle contract participant management.
2. **Gap: Contract-specific prescription data requirements** -- The specific contract-dependent prescription data fields and their enforcement need verification against each Selektivvertrag's requirements.

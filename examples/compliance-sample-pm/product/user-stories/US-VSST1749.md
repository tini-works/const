## US-VSST1749 — eDMP

| Field | Value |
|-------|-------|
| **ID** | US-VSST1749 |
| **Traced from** | [VSST1749](../compliances/SV/VSST1749.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | PAT, FRM |

### User Story

As a practice staff, I want eDMP, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given eDMP documentation, when triggered, then the eDMP workflow is available and functional

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/edmp`, `api/edoku`, `api/billing_edoku`, `api/mail`

1. **eDMP workflow** -- The `edmp` API package provides the complete eDMP lifecycle: enrollment, documentation, plausibility checking, billing validation, KIM mail transmission, and billing history.
2. **Multi-DMP support** -- The system supports multiple DMP types through `DMPLabelingValue`.
3. **Integration** -- The eDMP module integrates with patient profiles (OnPatientUpdate), billing (DMP billing validation), and mail (KIM mail for DMP data transmission).

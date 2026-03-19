## US-VSST592 — The following DMPs must be integrated per KBV specifications: eDMP...

| Field | Value |
|-------|-------|
| **ID** | US-VSST592 |
| **Traced from** | [VSST592](../compliances/SV/VSST592.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the following DMPs is integrated per KBV specifications: eDMP Diabetes Mellitus Type 1, Type 2, Koronare Herzkrankheit, Asthma, COPD, and Brustkrebs, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the Vertragssoftware, when DMP functionality is accessed, then eDMP modules for Diabetes Type 1, Type 2, KHK, Asthma, COPD, and Brustkrebs are available per KBV specifications

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/edmp`, `api/edoku`, `api/billing_edoku`

1. **eDMP module** -- The `edmp` API package implements a comprehensive eDMP system with: Enroll, Terminate, CreateDocument, GetEnrollment, SaveDocumentationOverview, FinishDocumentationOverview, CheckPlausibility, and DMP billing workflows.
2. **DMP labeling** -- The system supports multiple DMP types via `DMPLabelingValue` field, covering Diabetes Type 1/2, KHK, Asthma, COPD, and Brustkrebs.
3. **KBV-compliant documentation** -- The `edoku` and `billing_edoku` packages handle eDoku documentation per KBV specifications.
4. **DMP billing** -- Full DMP billing workflow with validation, KIM mail transmission, and billing history.

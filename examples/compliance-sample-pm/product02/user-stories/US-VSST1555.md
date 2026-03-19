## US-VSST1555 — VERAH TopVersorgt hint must be displayed when applicable

| Field | Value |
|-------|-------|
| **ID** | US-VSST1555 |
| **Traced from** | [VSST1555](../compliances/SV/VSST1555.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want vERAH TopVersorgt hint is displayed when applicable, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Patient eligible for VERAH TopVersorgt, when the record is opened, then the TopVersorgt hint is displayed

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/patient_profile`, `api/patient_sidebar`

1. **Patient context** -- The `patient_profile` and `patient_sidebar` packages provide patient data.
2. **Gap: VERAH TopVersorgt hint** -- The specific VERAH TopVersorgt eligibility check and hint display when a patient record is opened is not verified in the backend.

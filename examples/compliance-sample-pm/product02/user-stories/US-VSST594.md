## US-VSST594 — The Vertragssoftware must display the patient's employment status and type...

| Field | Value |
|-------|-------|
| **ID** | US-VSST594 |
| **Traced from** | [VSST594](../compliances/SV/VSST594.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware display the patient's employment status and type when issuing a work incapacity certificate (AU), with the ability to open and edit the documentation from the display, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given an AU is being issued, when the patient view loads, then employment status and type are displayed with a link to edit the documentation

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/eau`, `api/patient_profile`

1. **AU/eAU issuance** -- The `eau` API package implements full eAU workflow: CreateEAU, SignAndSendEAU, Print, CancelEAU.
2. **Patient profile integration** -- The eAU service subscribes to PatientProfileChange events.
3. **Gap: Employment status display during AU** -- The specific display of employment status and type when issuing an AU, with edit link, is a UI-level integration not verified in the backend.

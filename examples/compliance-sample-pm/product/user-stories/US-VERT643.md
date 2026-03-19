## US-VERT643 — System must check participation status

| Field | Value |
|-------|-------|
| **ID** | US-VERT643 |
| **Traced from** | [VERT643](../compliances/SV/VERT643.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want check participation status, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Patient, when Teilnahmestatus check is invoked, then the system queries HPM and returns the current status


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `CheckPatientParticipation` (PatientParticipationApp) queries HPM and returns current status. `CheckParticipation` (EnrollmentApp) also provides status checks with `ParticipationStatus` response.

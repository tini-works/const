## US-VERT494 — Participation status must be checkable

| Field | Value |
|-------|-------|
| **ID** | US-VERT494 |
| **Traced from** | [VERT494](../compliances/SV/VERT494.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, TNV, VTG |

### User Story

As a practice owner, I want participation status is checkable, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Patient in a Selektivvertrag, when participation status is queried, then the current Teilnahmestatus is returned


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `CheckParticipation` (EnrollmentApp) and `CheckPatientParticipation` (PatientParticipationApp) both query HPM and return the current participation status (`ParticipationStatus`) for a patient in a Selektivvertrag.

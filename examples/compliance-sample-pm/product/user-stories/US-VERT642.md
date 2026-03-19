## US-VERT642 — Participation status management — user must be able to view...

| Field | Value |
|-------|-------|
| **ID** | US-VERT642 |
| **Traced from** | [VERT642](../compliances/SV/VERT642.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, TNV |

### User Story

As a practice owner, I want participation status management — user is able to view current status, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Patient with Vertragsteilnahme, when the user opens status view, then the current Teilnahmestatus is displayed


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetPatientParticipation` (PatientParticipationApp) returns current participation status. `GetPatientEnrollment` returns enrollment details including status. `GetContractInformationFromAppCore` provides contract-level participation views.

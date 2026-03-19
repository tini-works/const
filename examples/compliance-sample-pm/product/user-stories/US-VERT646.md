## US-VERT646 — System must display participation status

| Field | Value |
|-------|-------|
| **ID** | US-VERT646 |
| **Traced from** | [VERT646](../compliances/SV/VERT646.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, TNV, VTG |

### User Story

As a practice owner, I want display participation status, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Patient with one or more Verträge, when the patient view is opened, then all Teilnahmestatus values are visible


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetPatientParticipation` returns all participation statuses for a patient. `GetPatientContractGroups` returns contract groups with participation info. `PatientParticipationChange` events notify the frontend of status changes via WebSocket for real-time display.

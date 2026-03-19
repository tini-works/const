## US-VERT833 — Participation status must auto-display

| Field | Value |
|-------|-------|
| **ID** | US-VERT833 |
| **Traced from** | [VERT833](../compliances/SV/VERT833.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want participation status auto-display, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Patient opened in the system, when the patient has Selektivvertrag-Teilnahme, then the status is automatically visible without manual query


### Actual Acceptance Criteria

**Status: Partially Implemented**

1. **Partially met.** `PatientParticipationChange` WebSocket events are emitted (via `PatientParticipationSocketNotifier`) which can trigger auto-display of status changes. `GetPatientParticipation` is available for status queries. However, automatic status display on patient open (without manual query) depends on frontend implementation.

## US-VERT890 — Contract participation must be tracked

| Field | Value |
|-------|-------|
| **ID** | US-VERT890 |
| **Traced from** | [VERT890](../compliances/SV/VERT890.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want contract participation is tracked, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given Vertragsteilnahme lifecycle events, when they occur, then all state changes are tracked with timestamps


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** Participation lifecycle is fully tracked. `ActionOnHzvContract`/`ActionOnFavContract` handle state transitions. `PatientParticipationChange` events are published. The enrollment repository persists all state changes. `GetPatientParticipation` returns historical participation data.

## US-VERT641 — User must be able to request participation

| Field | Value |
|-------|-------|
| **ID** | US-VERT641 |
| **Traced from** | [VERT641](../compliances/SV/VERT641.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, TNV |

### User Story

As a practice owner, I want user is able to request participation, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Patient eligible for a Vertrag, when the user submits a Teilnahmeantrag, then the request is persisted and sent to HPM


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `CreatePatientEnrollment` creates the participation request and persists it. `SendParticipation` transmits the request to HPM. The full flow (create + send) is available via the EnrollmentApp API.

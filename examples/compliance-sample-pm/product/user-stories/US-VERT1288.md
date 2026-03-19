## US-VERT1288 — User must be able to request participation

| Field | Value |
|-------|-------|
| **ID** | US-VERT1288 |
| **Traced from** | [VERT1288](../compliances/SV/VERT1288.md) |
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

1. Given a Patient, when the user initiates a Teilnahmeantrag, then the request is created and queued for transmission


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `CreatePatientEnrollment` creates the participation request and persists it. `SendParticipation` queues and transmits the request to HPM. `ReSubmitAllEnrollments` supports batch resubmission.

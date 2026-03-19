## US-VERT857 — FAV participation status must be verifiable

| Field | Value |
|-------|-------|
| **ID** | US-VERT857 |
| **Traced from** | [VERT857](../compliances/SV/VERT857.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, TNV, PM |

### User Story

As a practice owner, I want fAV participation status is verifiable, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a FAV-Patient, when participation verification is triggered, then the current FAV-Teilnahmestatus is confirmed via HPM


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** FAV participation verification is supported through `CheckParticipation` (EnrollmentApp) and `ActionOnFavContract`. The `service_fav.go` handles FAV-specific participation flows via HPM.

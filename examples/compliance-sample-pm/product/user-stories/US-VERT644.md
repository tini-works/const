## US-VERT644 — User must be able to end a contract participation

| Field | Value |
|-------|-------|
| **ID** | US-VERT644 |
| **Traced from** | [VERT644](../compliances/SV/VERT644.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want user is able to end a contract participation, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given an active Vertragsteilnahme, when the user triggers Kündigung, then the participation is ended and HPM is notified


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `ActionOnHzvContract` and `ActionOnFavContract` support lifecycle actions including termination (Kuendigung). The `EndParticipation`/`CancelParticipation` actions are handled through `ActionOnContractRequest` which is sent to HPM via `service_hzv.go` and `service_fav.go`.

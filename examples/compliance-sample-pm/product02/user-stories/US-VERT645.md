## US-VERT645 — User must be able to reverse a participation termination

| Field | Value |
|-------|-------|
| **ID** | US-VERT645 |
| **Traced from** | [VERT645](../compliances/SV/VERT645.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want user is able to reverse a participation termination, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a terminated Teilnahme, when the user triggers Stornierung der Kündigung, then the termination is reversed


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `ActionOnHzvContract` and `ActionOnFavContract` support reversal of termination (Stornierung der Kuendigung) as one of the lifecycle actions. The `ReverseTermination` action type is available in the `ActionOnContractRequest` flow, handled in `mapper_hzv.go` and `mapper_fav.go`.

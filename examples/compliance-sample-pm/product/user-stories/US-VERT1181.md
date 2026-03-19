## US-VERT1181 — Participation lifecycle must be fully manageable (activate, end, reverse, cancel)

| Field | Value |
|-------|-------|
| **ID** | US-VERT1181 |
| **Traced from** | [VERT1181](../compliances/SV/VERT1181.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want participation lifecycle is fully manageable (activate, end, reverse, cancel), so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Teilnahme, when the user performs activate/end/reverse/cancel, then each lifecycle transition succeeds and is persisted


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `ActionOnHzvContract` and `ActionOnFavContract` support the full participation lifecycle: activate, end (Kuendigung), reverse termination (Stornierung), and cancel. Each action is persisted and transmitted to HPM. The enrollment service (`service_hzv.go`, `service_fav.go`) implements these transitions.

## VERT644 — User must be able to end a contract participation

| Field | Value |
|-------|-------|
| **ID** | VERT644 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT644](../../user-stories/US-VERT644.md) |

### Requirement

User must be able to end a contract participation

### Acceptance Criteria

1. Given an active Vertragsteilnahme, when the user triggers Kündigung, then the participation is ended and HPM is notified

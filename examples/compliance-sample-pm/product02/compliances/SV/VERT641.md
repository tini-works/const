## VERT641 — User must be able to request participation

| Field | Value |
|-------|-------|
| **ID** | VERT641 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT641](../../user-stories/US-VERT641.md) |

### Requirement

User must be able to request participation

### Acceptance Criteria

1. Given a Patient eligible for a Vertrag, when the user submits a Teilnahmeantrag, then the request is persisted and sent to HPM

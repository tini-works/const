## VERT494 — Participation status must be checkable

| Field | Value |
|-------|-------|
| **ID** | VERT494 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT494](../../user-stories/US-VERT494.md) |

### Requirement

Participation status must be checkable

### Acceptance Criteria

1. Given a Patient in a Selektivvertrag, when participation status is queried, then the current Teilnahmestatus is returned

## VERT643 — System must check participation status

| Field | Value |
|-------|-------|
| **ID** | VERT643 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-3 |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT643](../../user-stories/US-VERT643.md) |

### Requirement

System must check participation status

### Acceptance Criteria

1. Given a Patient, when Teilnahmestatus check is invoked, then the system queries HPM and returns the current status

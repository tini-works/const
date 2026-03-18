## VERT648 — Participation window must be enforced

| Field | Value |
|-------|-------|
| **ID** | VERT648 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-3 |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT648](../../user-stories/US-VERT648.md) |

### Requirement

Participation window must be enforced

### Acceptance Criteria

1. Given a Vertrag with defined Teilnahmezeitraum, when actions are attempted outside the window, then they are blocked

## VERE564 — TE deletion must follow defined rules

| Field | Value |
|-------|-------|
| **ID** | VERE564 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.4 VERE — Patient Enrollment |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | E2E workflow test |
| Matched by | [US-VERE564](../../user-stories/US-VERE564.md) |

### Requirement

TE deletion must follow defined rules

### Acceptance Criteria

1. Given a TE, when deletion is attempted, then only TEs in permitted status are deletable; others are blocked

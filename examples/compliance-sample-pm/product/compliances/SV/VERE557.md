## VERE557 — TE editing must be restricted based on current status

| Field | Value |
|-------|-------|
| **ID** | VERE557 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.4 VERE — Patient Enrollment |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | E2E workflow test |
| Matched by | [US-VERE557](../../user-stories/US-VERE557.md) |

### Requirement

TE editing must be restricted based on current status

### Acceptance Criteria

1. Given a TE in status Erfolgreich, when the user attempts editing, then modifications are blocked

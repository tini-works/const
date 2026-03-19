## VERE560 — Transmission prerequisites must be met before TE can be sent

| Field | Value |
|-------|-------|
| **ID** | VERE560 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.4 VERE — Patient Enrollment |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | E2E workflow test |
| Matched by | [US-VERE560](../../user-stories/US-VERE560.md) |

### Requirement

Transmission prerequisites must be met before TE can be sent

### Acceptance Criteria

1. Given a TE for transmission, when prerequisites are unmet, then transmission is blocked with a checklist of missing items

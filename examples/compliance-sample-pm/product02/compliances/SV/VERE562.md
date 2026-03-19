## VERE562 — Failed TEs must be retryable; successful TEs must be blocked...

| Field | Value |
|-------|-------|
| **ID** | VERE562 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.4 VERE — Patient Enrollment |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | E2E workflow test |
| Matched by | [US-VERE562](../../user-stories/US-VERE562.md) |

### Requirement

Failed TEs must be retryable; successful TEs must be blocked from re-send

### Acceptance Criteria

1. Given a failed TE, when retry is attempted, then re-send proceeds
2. Given a successful TE, when re-send is attempted, then it is blocked

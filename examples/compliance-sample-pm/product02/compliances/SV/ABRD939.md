## ABRD939 — Blank billing codes must be assigned to the correct fee...

| Field | Value |
|-------|-------|
| **ID** | ABRD939 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD939](../../user-stories/US-ABRD939.md) |

### Requirement

Blank billing codes must be assigned to the correct fee schedule with proper availability when activated

### Acceptance Criteria

1. Given a Blanko-Code activation, when it is assigned to a Gebührenordnung, then it appears in the correct schedule with proper availability dates

## VERE450 — Enrollment receipt must be printable (DIN A6)

| Field | Value |
|-------|-------|
| **ID** | VERE450 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.4 VERE — Patient Enrollment |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | E2E workflow test |
| Matched by | [US-VERE450](../../user-stories/US-VERE450.md) |

### Requirement

Enrollment receipt must be printable (DIN A6)

### Acceptance Criteria

1. Given a completed Teilnahmeerklärung, when the user prints the receipt, then a DIN-A6 Empfangsbestätigung is generated

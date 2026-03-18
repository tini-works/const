## VERE554 — Correct enrollment form variant must be available per contract

| Field | Value |
|-------|-------|
| **ID** | VERE554 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.4 VERE — Patient Enrollment |
| **Status** | TBC |
| **Goals** | BG-1a, BG-3 |
| **Verification Method** | E2E workflow test |
| Matched by | [US-VERE554](../../user-stories/US-VERE554.md) |

### Requirement

Correct enrollment form variant must be available per contract

### Acceptance Criteria

1. Given a Vertrag with a specific TE-Formular, when TE is created, then the correct form variant is selected

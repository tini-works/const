## VERE792 — Module contract enrollment must be supported

| Field | Value |
|-------|-------|
| **ID** | VERE792 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.4 VERE — Patient Enrollment |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | E2E workflow test |
| Matched by | [US-VERE792](../../user-stories/US-VERE792.md) |

### Requirement

Module contract enrollment must be supported

### Acceptance Criteria

1. Given a Modulvertrag, when enrollment is initiated, then a module-specific TE is created linked to the Hauptvertrag

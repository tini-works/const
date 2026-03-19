## VERE556 — TE status lifecycle must be managed (Erzeugt → Gedruckt →...

| Field | Value |
|-------|-------|
| **ID** | VERE556 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.4 VERE — Patient Enrollment |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | E2E workflow test |
| Matched by | [US-VERE556](../../user-stories/US-VERE556.md) |

### Requirement

TE status lifecycle must be managed (Erzeugt → Gedruckt → Fehlerhaft → Erfolgreich)

### Acceptance Criteria

1. Given a TE, when it transitions through Erzeugt/Gedruckt/Fehlerhaft/Erfolgreich, then each status change is tracked and displayed

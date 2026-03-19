## ABRD606 — Service lookup must filter by IK assignment

| Field | Value |
|-------|-------|
| **ID** | ABRD606 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-3 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD606](../../user-stories/US-ABRD606.md) |

### Requirement

Service lookup must filter by IK assignment

### Acceptance Criteria

1. Given a Patient with a specific IK-Zuordnung, when the user searches Leistungen, then only services matching that IK are shown

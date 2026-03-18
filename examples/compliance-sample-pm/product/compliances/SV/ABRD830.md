## ABRD830 — Service lookup must filter by IK group

| Field | Value |
|-------|-------|
| **ID** | ABRD830 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-3 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD830](../../user-stories/US-ABRD830.md) |

### Requirement

Service lookup must filter by IK group

### Acceptance Criteria

1. Given a Leistungssuche, when the Patient belongs to an IK-Gruppe, then only services valid for that IK-Gruppe are returned

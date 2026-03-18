## ABRD603 — Service lookup must filter by KV region

| Field | Value |
|-------|-------|
| **ID** | ABRD603 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-3 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD603](../../user-stories/US-ABRD603.md) |

### Requirement

Service lookup must filter by KV region

### Acceptance Criteria

1. Given a Praxis in KV-Region X, when the user searches Leistungen, then only services valid for that KV-Region are shown

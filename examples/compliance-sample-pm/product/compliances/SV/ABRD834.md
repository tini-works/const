## ABRD834 — FAV service documentation must verify patient's active FAV participation before...

| Field | Value |
|-------|-------|
| **ID** | ABRD834 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD834](../../user-stories/US-ABRD834.md) |

### Requirement

FAV service documentation must verify patient's active FAV participation before allowing service entry

### Acceptance Criteria

1. Given a Patient without active FAV-Teilnahme, when a FAV-Leistung is entered, then the system blocks entry with a participation error

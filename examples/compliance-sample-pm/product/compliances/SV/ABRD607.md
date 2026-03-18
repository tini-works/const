## ABRD607 — Services submitted for billing must be protected from deletion to...

| Field | Value |
|-------|-------|
| **ID** | ABRD607 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD607](../../user-stories/US-ABRD607.md) |

### Requirement

Services submitted for billing must be protected from deletion to maintain audit trail

### Acceptance Criteria

1. Given a Leistung already submitted for Abrechnung, when a user attempts deletion, then deletion is blocked and an audit entry is preserved

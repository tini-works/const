## ABRD605 — Service documentation is only permitted when the patient has active...

| Field | Value |
|-------|-------|
| **ID** | ABRD605 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD605](../../user-stories/US-ABRD605.md) |

### Requirement

Service documentation is only permitted when the patient has active contract participation status

### Acceptance Criteria

1. Given a Patient without active Teilnahmestatus, when a Selektivvertrag-Leistung is entered, then the system blocks the entry

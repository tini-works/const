## ABRD995 — Billing justification text must be capturable for services requiring explanation...

| Field | Value |
|-------|-------|
| **ID** | ABRD995 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD995](../../user-stories/US-ABRD995.md) |

### Requirement

Billing justification text must be capturable for services requiring explanation of medical necessity

### Acceptance Criteria

1. Given a Leistung requiring Begründungstext, when no justification is entered, then validation warns before submission

## ABRG454 — Billing process must be controllable per contract rules

| Field | Value |
|-------|-------|
| **ID** | ABRG454 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG454](../../user-stories/US-ABRG454.md) |

### Requirement

Billing process must be controllable per contract rules

### Acceptance Criteria

1. Given contract-specific Abrechnungsregeln, when the billing process runs, then only contract-permitted operations are executed

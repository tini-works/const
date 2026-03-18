## VERT645 — User must be able to reverse a participation termination

| Field | Value |
|-------|-------|
| **ID** | VERT645 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT645](../../user-stories/US-VERT645.md) |

### Requirement

User must be able to reverse a participation termination

### Acceptance Criteria

1. Given a terminated Teilnahme, when the user triggers Stornierung der Kündigung, then the termination is reversed

## ABRD514 — System must warn when an acute diagnosis is marked as...

| Field | Value |
|-------|-------|
| **ID** | ABRD514 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-4 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD514](../../user-stories/US-ABRD514.md) |

### Requirement

System must warn when an acute diagnosis is marked as permanent, as this blocks chronic care flat-rate billing

### Acceptance Criteria

1. Given an akute Diagnose being marked as Dauerdiagnose, when the user confirms, then a warning about Chronikerpauschale blocking is displayed

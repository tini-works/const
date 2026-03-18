## ABRD969 — System must warn when an acute diagnosis is marked as...

| Field | Value |
|-------|-------|
| **ID** | ABRD969 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-4 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD969](../../user-stories/US-ABRD969.md) |

### Requirement

System must warn when an acute diagnosis is marked as permanent (implausible documentation)

### Acceptance Criteria

1. Given an akute Diagnose being set as Dauerdiagnose, when saved, then a plausibility warning is displayed

## VERT649 — System must check for insurance changes and trigger re-enrollment notices

| Field | Value |
|-------|-------|
| **ID** | VERT649 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-3 |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT649](../../user-stories/US-VERT649.md) |

### Requirement

System must check for insurance changes and trigger re-enrollment notices

### Acceptance Criteria

1. Given a Kassenwechsel detected, when the patient has active Teilnahme, then a re-enrollment notice is triggered

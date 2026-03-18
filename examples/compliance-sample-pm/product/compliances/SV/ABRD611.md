## ABRD611 — System must inform users during diagnosis entry when a more...

| Field | Value |
|-------|-------|
| **ID** | ABRD611 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD611](../../user-stories/US-ABRD611.md) |

### Requirement

System must inform users during diagnosis entry when a more specific ICD-10 terminal code is available

### Acceptance Criteria

1. Given a non-terminal ICD-10-Code entered, when a more specific Endstellencode exists, then the system displays a specificity hint

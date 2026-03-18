## ABRD679 — ICD-10 validity must be checked against current catalog

| Field | Value |
|-------|-------|
| **ID** | ABRD679 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD679](../../user-stories/US-ABRD679.md) |

### Requirement

ICD-10 validity must be checked against current catalog

### Acceptance Criteria

1. Given an ICD-10-Code entered, when it is not in the current Katalogversion, then a validation error is displayed

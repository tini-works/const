## ABRD612 — Confirmed diagnoses ('G') must be documented as terminal codes, not...

| Field | Value |
|-------|-------|
| **ID** | ABRD612 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-4 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD612](../../user-stories/US-ABRD612.md) |

### Requirement

Confirmed diagnoses ('G') must be documented as terminal codes, not group codes

### Acceptance Criteria

1. Given a gesicherte Diagnose ('G'), when it is a Gruppencode, then validation rejects it and requests an Endstellencode

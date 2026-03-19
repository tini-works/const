## VSST923 — High-volume prescription control must warn the user

| Field | Value |
|-------|-------|
| **ID** | VSST923 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a, BG-4 |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST923](../../user-stories/US-VSST923.md) |

### Requirement

High-volume prescription control must warn the user

### Acceptance Criteria

1. Given a Verordnung exceeding volume thresholds, when saved, then a Hochvolumen warning is displayed to the user

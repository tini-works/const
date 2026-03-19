## VSST621 — The Vertragssoftware must prevent issuing an AU or eAU when...

| Field | Value |
|-------|-------|
| **ID** | VSST621 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST621](../../user-stories/US-VSST621.md) |

### Requirement

The Vertragssoftware must prevent issuing an AU or eAU when the patient's employment status and type are not filled or not current

### Acceptance Criteria

1. Given a patient with empty or outdated employment data, when an AU or eAU issuance is attempted, then the system blocks issuance until employment data is current

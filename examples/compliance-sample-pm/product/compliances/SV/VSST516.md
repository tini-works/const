## VSST516 — The Vertragssoftware must currently not allow transmission of prescription data...

| Field | Value |
|-------|-------|
| **ID** | VSST516 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST516](../../user-stories/US-VSST516.md) |

### Requirement

The Vertragssoftware must currently not allow transmission of prescription data (Verordnungsdaten), but the documentation must support retroactive transmission at a later date

### Acceptance Criteria

1. Given the current system state, when the user attempts to transmit Verordnungsdaten, then transmission is blocked
2. Given the documentation structure, then it supports future retroactive transmission

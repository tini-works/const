## VSST496 — The Vertragssoftware must mark all transmitted prescription data (Verordnungsdaten) as...

| Field | Value |
|-------|-------|
| **ID** | VSST496 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST496](../../user-stories/US-VSST496.md) |

### Requirement

The Vertragssoftware must mark all transmitted prescription data (Verordnungsdaten) as billed after successful data transmission

### Acceptance Criteria

1. Given successful prescription data transmission, when the process completes, then all transmitted Verordnungen are flagged as 'abgerechnet'

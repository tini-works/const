## VSST527 — KBV AVWG prescription catalog must be enforced

| Field | Value |
|-------|-------|
| **ID** | VSST527 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1, KBV AVWG |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST527](../../user-stories/US-VSST527.md) |

### Requirement

KBV AVWG prescription catalog must be enforced

### Acceptance Criteria

1. Given a Verordnung, when a drug is prescribed, then AVWG catalog rules are enforced and violations are flagged

## VSST977 — Instead of KBV AVWG P3-130 for OTC exception indication display...

| Field | Value |
|-------|-------|
| **ID** | VSST977 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST977](../../user-stories/US-VSST977.md) |

### Requirement

Instead of KBV AVWG P3-130 for OTC exception indication display per AM-RL Anlage I, the rule must only apply to contract participants aged 18 and older

### Acceptance Criteria

1. Given an OTC exception indication per AM-RL Anlage I, when the patient is a contract participant under 18, then the indication is not displayed
2. Given age 18+, then it is displayed

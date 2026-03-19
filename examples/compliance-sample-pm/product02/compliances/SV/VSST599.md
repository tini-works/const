## VSST599 — When issuing an AU or eAU, the Vertragssoftware must display...

| Field | Value |
|-------|-------|
| **ID** | VSST599 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST599](../../user-stories/US-VSST599.md) |

### Requirement

When issuing an AU or eAU, the Vertragssoftware must display a hint if employment data is empty or older than 1 year, requesting the user to fill in employment status before issuing the AU

### Acceptance Criteria

1. Given empty or outdated (>1 year) employment data, when an AU or eAU is issued, then a hint requests the user to fill in employment data before issuing

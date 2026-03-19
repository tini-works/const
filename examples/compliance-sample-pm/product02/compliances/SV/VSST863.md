## VSST863 — When issuing a repeat prescription (Wiederholungsrezept), the current insurance-specific medication...

| Field | Value |
|-------|-------|
| **ID** | VSST863 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST863](../../user-stories/US-VSST863.md) |

### Requirement

When issuing a repeat prescription (Wiederholungsrezept), the current insurance-specific medication recommendations must be retrieved and displayed, checking whether the medication's category has changed and showing substitution options per the interface specification

### Acceptance Criteria

1. Given a repeat prescription, when issued, then current insurance-specific recommendations are retrieved, category changes are checked, and substitution options are displayed per interface specification

## VSST976 — After successful real-data transmission of prescription data, the Vertragssoftware must...

| Field | Value |
|-------|-------|
| **ID** | VSST976 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST976](../../user-stories/US-VSST976.md) |

### Requirement

After successful real-data transmission of prescription data, the Vertragssoftware must display the count of successfully transmitted prescriptions; test transmissions must not show counts; deleted prescriptions must be excluded from the count

### Acceptance Criteria

1. Given successful real-data prescription transmission, when complete, then the count of transmitted prescriptions is shown
2. Given test transmission, then count is not shown
3. Given deleted prescriptions, then they are excluded from the count

## VSST848 — When ICD-10 codes F32.9 or F33.9 (unspecified depressive episodes) are...

| Field | Value |
|-------|-------|
| **ID** | VSST848 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST848](../../user-stories/US-VSST848.md) |

### Requirement

When ICD-10 codes F32.9 or F33.9 (unspecified depressive episodes) are documented, from the first follow-up AU certificate onward, the system must display: 'Please check whether targeted diagnostic and therapeutic measures could improve the disease course in continued AU due to unspecific depression.'

### Acceptance Criteria

1. Given ICD-10 F32.9 or F33.9 documented, when a Folge-AU is issued, then the hint about considering targeted diagnostic/therapeutic measures for unspecific depression is displayed

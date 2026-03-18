## FORM815 — If the 'Schnellinformation zur Patientenbegleitung' form is not printed, the...

| Field | Value |
|-------|-------|
| **ID** | FORM815 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.5 FORM — Form Management |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Form output check |
| Matched by | [US-FORM815](../../user-stories/US-FORM815.md) |

### Requirement

If the 'Schnellinformation zur Patientenbegleitung' form is not printed, the Vertragssoftware must display a confirmation dialog asking whether the user intentionally skips sending the quick information to the insurance, noting that early intervention may help mitigate illness consequences

### Acceptance Criteria

1. Given the Schnellinformation form is not printed, when the user closes it, then a confirmation dialog asks whether the user intentionally skips, explaining that early insurer intervention may help

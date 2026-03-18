## VSST631 — When prescribing a steuerbare Hilfsmittel, the Vertragssoftware must display the...

| Field | Value |
|-------|-------|
| **ID** | VSST631 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST631](../../user-stories/US-VSST631.md) |

### Requirement

When prescribing a steuerbare Hilfsmittel, the Vertragssoftware must display the hint: 'Please fax the prescription (Muster 16) and any questionnaire to the fax number printed on the Muster 16'

### Acceptance Criteria

1. Given a steuerbare Hilfsmittel prescription, when the user is prescribing, then the fax instruction hint is displayed

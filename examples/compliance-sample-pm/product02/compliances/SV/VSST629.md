## VSST629 — When prescribing a steuerbare Hilfsmittel, the Vertragssoftware must check whether...

| Field | Value |
|-------|-------|
| **ID** | VSST629 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST629](../../user-stories/US-VSST629.md) |

### Requirement

When prescribing a steuerbare Hilfsmittel, the Vertragssoftware must check whether a questionnaire (Fragebogen) is required by verifying whether the FRAGEBOGEN column in the steuerbare Hilfsmittel list is non-empty

### Acceptance Criteria

1. Given a steuerbare Hilfsmittel, when its FRAGEBOGEN column is non-empty, then the system requires the user to fill out the questionnaire

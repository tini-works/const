## VSST630 — The Vertragssoftware must validate the completed steuerbare Hilfsmittel questionnaire against...

| Field | Value |
|-------|-------|
| **ID** | VSST630 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST630](../../user-stories/US-VSST630.md) |

### Requirement

The Vertragssoftware must validate the completed steuerbare Hilfsmittel questionnaire against its rules and warn the user if the questionnaire is not properly filled, with validation occurring at latest before saving or printing

### Acceptance Criteria

1. Given a completed steuerbare Hilfsmittel questionnaire, when validation runs before save/print, then non-compliant answers are flagged with a warning

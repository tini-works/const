## VSST627 — When prescribing a Hilfsmittel, the Vertragssoftware must check against the...

| Field | Value |
|-------|-------|
| **ID** | VSST627 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST627](../../user-stories/US-VSST627.md) |

### Requirement

When prescribing a Hilfsmittel, the Vertragssoftware must check against the steuerbare Hilfsmittel list using the 7-digit Positionsnummer and display/collect additional data as specified

### Acceptance Criteria

1. Given a Hilfsmittel being prescribed, when its 7-digit Positionsnummer matches the steuerbare list, then additional data fields per the list specification are displayed and required

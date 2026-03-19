## VSST551 — When prescribing medications of categories 'Gruen', 'GruenBerechnet', or 'Blau', the...

| Field | Value |
|-------|-------|
| **ID** | VSST551 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST551](../../user-stories/US-VSST551.md) |

### Requirement

When prescribing medications of categories 'Gruen', 'GruenBerechnet', or 'Blau', the Vertragssoftware must retrieve and display any messages from the Pruef- und Abrechnungsmodul via the substitution and list endpoints

### Acceptance Criteria

1. Given a medication of category Gruen, GruenBerechnet, or Blau being prescribed, when the Pruef- und Abrechnungsmodul returns messages, then those messages are displayed to the user

## VSST541 — When prescribing medications of categories 'Rot', 'Orange', or 'keine', the...

| Field | Value |
|-------|-------|
| **ID** | VSST541 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST541](../../user-stories/US-VSST541.md) |

### Requirement

When prescribing medications of categories 'Rot', 'Orange', or 'keine', the Vertragssoftware must retrieve and display insurance-specific medication recommendations (kassenspezifische Arzneimittelempfehlungen) via the Pruef- und Abrechnungsmodul; no further recommendation check is needed when a substitute is selected

### Acceptance Criteria

1. Given a medication of category Rot, Orange, or 'keine' being prescribed, when the system queries HPM, then insurance-specific recommendations are displayed
2. Given a substitute is selected from recommendations, then no further recommendation check occurs

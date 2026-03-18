## US-VSST541 — When prescribing medications of categories 'Rot', 'Orange', or 'keine', the...

| Field | Value |
|-------|-------|
| **ID** | US-VSST541 |
| **Traced from** | [VSST541](../compliances/SV/VSST541.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want when prescribing medications of categories 'Rot', 'Orange', or 'keine', the Vertragssoftware retrieve and display insurance-specific medication recommendations (kassenspezifische Arzneimittelempfehlungen) via the Pruef- und Abrechnungsmodul; no further recommendation check is needed when a substitute is selected, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a medication of category Rot, Orange, or 'keine' being prescribed, when the system queries HPM, then insurance-specific recommendations are displayed
2. Given a substitute is selected from recommendations, then no further recommendation check occurs

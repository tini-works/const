## VSST624 — The Vertragssoftware must support Hilfsmittel searches by: product search, application...

| Field | Value |
|-------|-------|
| **ID** | VSST624 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST624](../../user-stories/US-VSST624.md) |

### Requirement

The Vertragssoftware must support Hilfsmittel searches by: product search, application location, subgroup, product type, manufacturer, product name, and keyword (THESAURUS); catalog search must be the preferred path, with direct entry not shown as equivalent

### Acceptance Criteria

1. Given a Hilfsmittel search, when the user enters search criteria (product, application location, subgroup, type, manufacturer, name, keyword), then matching results are returned
2. Given the UI, then catalog search is the primary path, not direct entry

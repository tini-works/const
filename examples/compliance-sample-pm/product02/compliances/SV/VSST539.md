## VSST539 — In practice-level and patient-level medication lists and catalog searches, the...

| Field | Value |
|-------|-------|
| **ID** | VSST539 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST539](../../user-stories/US-VSST539.md) |

### Requirement

In practice-level and patient-level medication lists and catalog searches, the Vertragssoftware must not display prices for medications in categories 'Gruen' and 'Blau'; instead, the word 'rabattiert' must be shown. Individual categories may be absent per contract

### Acceptance Criteria

1. Given a medication of category Gruen or Blau, when displayed in practice/patient lists or search results, then 'rabattiert' is shown instead of the price

## VSST548 — The Vertragssoftware must display medications sorted starting with categories 'Gruen'...

| Field | Value |
|-------|-------|
| **ID** | VSST548 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST548](../../user-stories/US-VSST548.md) |

### Requirement

The Vertragssoftware must display medications sorted starting with categories 'Gruen' and 'Blau' in all search results, or provide a filter showing only 'Gruen' and/or 'Blau' with a 'Show all' function to override the filter in individual cases

### Acceptance Criteria

1. Given medication search results, when displayed, then Gruen and Blau categories appear first, or a filter limits display to those categories with a 'Show all' override available

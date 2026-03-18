## VSST962 — The Hilfsmittelkatalog and catalog searches must be strictly sorted by...

| Field | Value |
|-------|-------|
| **ID** | VSST962 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST962](../../user-stories/US-VSST962.md) |

### Requirement

The Hilfsmittelkatalog and catalog searches must be strictly sorted by Produktgruppe, Anwendungsort, Untergruppe, Produktart, including when using a custom catalog

### Acceptance Criteria

1. Given the Hilfsmittelkatalog, when a search is performed, then results are sorted strictly by Produktgruppe, Anwendungsort, Untergruppe, Produktart

## VSST623 — The Vertragssoftware must integrate the Hilfsmittelkatalog provided via AKA-Basisdatei to...

| Field | Value |
|-------|-------|
| **ID** | VSST623 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST623](../../user-stories/US-VSST623.md) |

### Requirement

The Vertragssoftware must integrate the Hilfsmittelkatalog provided via AKA-Basisdatei to assist with medical device selection; if the software has its own catalog, it may be used provided the described functions are implemented

### Acceptance Criteria

1. Given the AKA Hilfsmittelkatalog, when the system loads, then the catalog is available for Hilfsmittel selection with the specified search and display functions

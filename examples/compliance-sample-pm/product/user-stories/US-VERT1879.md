## US-VERT1879 — After a full import (Vollimport), the Vertragssoftware must display an...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1879 |
| **Traced from** | [VERT1879](../compliances/SV/VERT1879.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want after a full import (Vollimport), the Vertragssoftware display an import protocol showing: contract, VP-ID, quarter/year, importing user, import type (Vollimport), timestamp, and detailed import results, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Vollimport completes, when the protocol is displayed, then it shows: contract, VP-ID, quarter/year, user, type (Vollimport), timestamp, and itemized results


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetListPtvImportHistory` returns Vollimport protocol records with contract, VP-ID, quarter/year, user, import type (Vollimport), timestamp, and itemized results. The `ImportHistoryTracker.CompleteImport` records the import type via `request.ImportType`.

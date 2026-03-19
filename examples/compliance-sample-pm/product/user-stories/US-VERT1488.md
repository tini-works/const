## US-VERT1488 — The Vertragssoftware must provide an overview of all previously imported...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1488 |
| **Traced from** | [VERT1488](../compliances/SV/VERT1488.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TNV, ARZ, QTR |

### User Story

As a practice owner, I want the Vertragssoftware provide an overview of all previously imported Patiententeilnehmerverzeichnisse showing contract, physician name/LANR, quarter/year, importing user, import timestamp, and link to the import protocol, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given imported Patiententeilnehmerverzeichnisse exist, when the user opens the overview, then each entry shows contract, physician name/LANR, quarter/year, importing user, import date/time, and protocol link


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetListPtvImportHistory` returns paginated import history records (`PtvImportHistory`) including contract, quarter/year, version, and import status. The `ImportHistoryTracker` records document ID, doctor ID, contract ID, year, quarter, code, and version for each import.

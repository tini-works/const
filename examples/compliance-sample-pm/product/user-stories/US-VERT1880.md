## US-VERT1880 — The Vertragssoftware must allow importing a Patiententeilnehmerverzeichnis even when a...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1880 |
| **Traced from** | [VERT1880](../compliances/SV/VERT1880.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TNV, PAT |

### User Story

As a practice owner, I want the Vertragssoftware allow importing a Patiententeilnehmerverzeichnis even when a previously initiated Vollimport has not yet completed, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Vollimport is in progress, when the user initiates a new Patiententeilnehmerverzeichnis import, then the new import is allowed to proceed


### Actual Acceptance Criteria

**Status: Partially Implemented**

1. **Partially met.** The PTV import uses separate `PtvImportId` per import session and tracks state via `ImportHistoryTracker`. There is no explicit mutex or lock that would block concurrent imports. However, there is no explicit concurrency handling that guarantees safe parallel imports -- the design appears to allow it but does not explicitly document or test this scenario.

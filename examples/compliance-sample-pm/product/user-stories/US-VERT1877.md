## US-VERT1877 — After a standard import, the Vertragssoftware must display an import...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1877 |
| **Traced from** | [VERT1877](../compliances/SV/VERT1877.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TNV, VTG, ARZ |

### User Story

As a practice owner, I want after a standard import, the Vertragssoftware display an import protocol showing: contract of the imported Patiententeilnehmerverzeichnis, VP-ID of the Vertragspartner, quarter/year, importing user, import type (Standardimport), timestamp, and detailed import results, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a standard import completes, when the protocol is displayed, then it shows: contract, VP-ID, quarter/year, user, type (Standardimport), timestamp, and itemized results


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetListPtvImportHistory` returns import protocol records. The `ImportHistoryTracker` records contract, VP-ID (via doctor's `HavgVpId`), quarter/year, importing user (from context), import type, timestamp, and detailed results (classified participants with counts: `BeforeParticipantCount`, `AfterParticipantCount`).

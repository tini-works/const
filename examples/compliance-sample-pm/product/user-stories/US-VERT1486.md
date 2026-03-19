## US-VERT1486 — The Vertragssoftware must warn the user before re-importing a Patiententeilnehmerverzeichnis...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1486 |
| **Traced from** | [VERT1486](../compliances/SV/VERT1486.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TNV, QTR, VTG |

### User Story

As a practice owner, I want the Vertragssoftware warn the user before re-importing a Patiententeilnehmerverzeichnis for the same Vertragspartner/Quartal/Jahr/Vertrag and allow cancellation of the import, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Patiententeilnehmerverzeichnis already imported for the same VP/quarter/year/contract, when the user attempts re-import, then a warning is displayed and the user can cancel


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** The `hashXmlContent` function generates a content hash per doctor/year/quarter/XML. `GetPtvImportByHash` checks for existing imports. When a re-import is detected (`isPtvImportExists`), the system checks version ordering before allowing the import to proceed.

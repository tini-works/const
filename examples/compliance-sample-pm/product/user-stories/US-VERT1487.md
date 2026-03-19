## US-VERT1487 — The Vertragssoftware must prevent importing a Patiententeilnehmerverzeichnis if a more...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1487 |
| **Traced from** | [VERT1487](../compliances/SV/VERT1487.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want the Vertragssoftware prevent importing a Patiententeilnehmerverzeichnis if a more recent quarter has already been imported for the same Vertragspartner and Vertrag, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Patiententeilnehmerverzeichnis for a newer quarter already imported, when the user attempts to import an older quarter, then the import is blocked


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** Quarter-based ordering is enforced: `uploadingTime < latestTime` check (using year*4 + quarter calculation) blocks importing older quarters when a newer quarter exists, returning `ErrorCode_PTV_Import_Older_Than_Latest`.

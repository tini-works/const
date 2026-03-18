## US-VERT1482 — The Vertragssoftware must allow the user to query via HTTP...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1482 |
| **Traced from** | [VERT1482](../compliances/SV/VERT1482.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want the Vertragssoftware allow the user to query via HTTP POST to the HPM endpoint whether patient participant directories (Patiententeilnehmerverzeichnisse) are available for download, show which directories have already been imported, and let the user initiate the download, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Vertragspartner VP-ID, when the user queries available directories via HPM, then the system shows which contracts have downloadable Patiententeilnehmerverzeichnisse and which have already been imported

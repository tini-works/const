## US-VSST1106 — The Vertragssoftware must allow managing the URL for the PraCMan-Cockpit...

| Field | Value |
|-------|-------|
| **ID** | US-VSST1106 |
| **Traced from** | [VSST1106](../compliances/SV/VSST1106.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | PVS |

### User Story

As a practice staff, I want the Vertragssoftware allow managing the URL for the PraCMan-Cockpit to enable launching it from within the software per the AKA-Basisdatei interface specification, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the PraCMan-Cockpit URL is configured, when the user manages it, then the URL can be set, updated, and used to launch PraCMan from the software

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/settings`

1. **Settings infrastructure** -- The `settings` API package provides system configuration management.
2. **Gap: PraCMan-Cockpit URL management** -- The specific management of PraCMan-Cockpit URL within settings per AKA-Basisdatei interface specification is not verified.

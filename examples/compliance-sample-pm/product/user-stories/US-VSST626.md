## US-VSST626 — The Vertragssoftware must integrate the list of steerable Hilfsmittel (steuerbare...

| Field | Value |
|-------|-------|
| **ID** | US-VSST626 |
| **Traced from** | [VSST626](../compliances/SV/VSST626.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, KAT |

### User Story

As a practice staff, I want the Vertragssoftware integrate the list of steerable Hilfsmittel (steuerbare Hilfsmittel) from AKA-Basisdatei, which contains devices requiring special Versorgungssteuerung from the insurance perspective, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the AKA steuerbare Hilfsmittel list, when the system loads, then the list is integrated and available for prescription checks

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/himi`

1. **Steuerbare Hilfsmittel** -- The `SearchControllableHimi` method in the `HimiApp` interface specifically handles steuerbare Hilfsmittel list searches.
2. **Catalog integration** -- The HIMI service integrates the steuerbare Hilfsmittel list from AKA-Basisdatei.

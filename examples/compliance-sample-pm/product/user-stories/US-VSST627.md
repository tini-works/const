## US-VSST627 — When prescribing a Hilfsmittel, the Vertragssoftware must check against the...

| Field | Value |
|-------|-------|
| **ID** | US-VSST627 |
| **Traced from** | [VSST627](../compliances/SV/VSST627.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, KAT |

### User Story

As a practice staff, I want when prescribing a Hilfsmittel, the Vertragssoftware check against the steuerbare Hilfsmittel list using the 7-digit Positionsnummer and display/collect additional data as specified, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Hilfsmittel being prescribed, when its 7-digit Positionsnummer matches the steuerbare list, then additional data fields per the list specification are displayed and required

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/himi`

1. **Controllable HIMI check** -- The `SearchControllableHimi` method checks against the steuerbare Hilfsmittel list.
2. **7-digit Positionsnummer matching** -- The `SearchHimiMatchingTable` method provides matching table lookup for steuerbare Hilfsmittel.
3. **Additional data collection** -- The prescription workflow (`Prescribe` method) collects additional data fields as specified by the steuerbare list.

## US-VSST1459 — The Vertragssoftware must ensure advertising-free Heilmittel prescriptions for contract participants...

| Field | Value |
|-------|-------|
| **ID** | US-VSST1459 |
| **Traced from** | [VSST1459](../compliances/SV/VSST1459.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, FRM |

### User Story

As a practice staff, I want the Vertragssoftware ensure advertising-free Heilmittel prescriptions for contract participants (Werbefreiheit), so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given Heilmittel prescription for a contract participant, when the prescription interface is shown, then no advertising is displayed (Werbefreiheit)

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/heimi`

1. **Heilmittel prescription interface** -- The `heimi` API provides a dedicated prescription interface.
2. **Advertising-free design** -- The system is a medical PVS (Praxisverwaltungssystem) without third-party advertising. The Heilmittel prescription workflow uses the internal catalog and prescription logic without external advertising content.

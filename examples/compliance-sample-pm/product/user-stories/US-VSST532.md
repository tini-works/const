## US-VSST532 — Prescription data structure

| Field | Value |
|-------|-------|
| **ID** | US-VSST532 |
| **Traced from** | [VSST532](../compliances/SV/VSST532.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD |

### User Story

As a practice staff, I want prescription data structure, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Verordnung, when created, then the data structure matches the required Verordnungsdatenstruktur specification

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/medicine_kbv`, `api/erezept`

1. **Prescription data structure** -- The `medicine` API package defines comprehensive Verordnung data structures. The `erezept` package implements the electronic prescription format.
2. **KBV-compliant structure** -- The `medicine_kbv` package ensures prescriptions conform to KBV data structure requirements.

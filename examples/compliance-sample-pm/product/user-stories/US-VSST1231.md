## US-VSST1231 — The Vertragssoftware must offer all Versorgungssteuerung functions to the substitute...

| Field | Value |
|-------|-------|
| **ID** | US-VSST1231 |
| **Traced from** | [VSST1231](../compliances/SV/VSST1231.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | ARZ, PVS |

### User Story

As a practice staff, I want the Vertragssoftware offer all Versorgungssteuerung functions to the substitute physician (Stellvertreterarzt) that also apply to the primary care physician (Betreuarzt), so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Stellvertreterarzt, when providing care, then all Versorgungssteuerung functions available to the Betreuarzt are also available

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/auth`, `api/enrollment`

1. **Doctor management** -- The system supports multiple doctor contexts through DoctorId parameters in prescription and billing workflows.
2. **Gap: Stellvertreterarzt parity** -- The specific enforcement that all Versorgungssteuerung functions available to the Betreuarzt are equally available to the Stellvertreterarzt needs verification in authorization rules.

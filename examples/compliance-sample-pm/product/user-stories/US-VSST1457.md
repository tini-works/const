## US-VSST1457 — The KBV Heilmittel catalog requirements apply analogously to the Vertragssoftware...

| Field | Value |
|-------|-------|
| **ID** | US-VSST1457 |
| **Traced from** | [VSST1457](../compliances/SV/VSST1457.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, FRM |

### User Story

As a practice staff, I want the KBV Heilmittel catalog requirements apply analogously to the Vertragssoftware unless otherwise specified by the HAEVG catalog; specific function IDs are listed, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the KBV Heilmittel catalog requirements, when Heilmittel prescriptions are processed, then all listed functions apply unless HAEVG specifies otherwise

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/heimi`

1. **Heilmittel (Heimi) module** -- The `heimi` API package implements comprehensive Heilmittel functionality: GetHeimiArea, GetDiagnoseLabel, GetDiagnoseGroup, GetKeySymptoms, GetRemedy, GetTherapyFrequency, Prescribe, Print, and more.
2. **Catalog integration** -- The Heimi module includes diagnosis-based remedy lookup, therapy frequency management, and prescription statistics.
3. **KBV-compliant workflow** -- The prescription workflow follows KBV Heilmittel patterns with diagnosis groups, key symptoms, remedy selection, and indicator prescriptions.

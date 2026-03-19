## US-VSST784 — PIM drug labels must be displayed

| Field | Value |
|-------|-------|
| **ID** | US-VSST784 |
| **Traced from** | [VSST784](../compliances/SV/VSST784.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want pIM drug labels is displayed, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Verordnung for an elderly patient, when a PRISCUS/PIM drug is selected, then a PIM warning label is displayed

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/medicine_kbv`

1. **Medication data** -- The `medicine` and `medicine_kbv` packages handle medication data including drug properties.
2. **Gap: PIM/PRISCUS label display** -- The specific display of PIM (Potentially Inappropriate Medications) / PRISCUS labels for elderly patients during prescription needs verification. The medicine service may include PRISCUS data but the display logic is not confirmed.

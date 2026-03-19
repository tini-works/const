## US-VSST1543 — AVWG including ARV

| Field | Value |
|-------|-------|
| **ID** | US-VSST1543 |
| **Traced from** | [VSST1543](../compliances/SV/VSST1543.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want aVWG including ARV, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Verordnung, when AVWG rules including ARV are checked, then violations are flagged

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine_kbv`, `api/coding_rule`

1. **AVWG rule integration** -- The `medicine_kbv` package implements KBV AVWG medication rules.
2. **Gap: ARV inclusion** -- The specific inclusion of ARV (Arzneiverordnungs-Richtlinie) rules alongside AVWG rules needs verification for completeness.

## US-VSST923 — High-volume prescription control must warn the user

| Field | Value |
|-------|-------|
| **ID** | US-VSST923 |
| **Traced from** | [VSST923](../compliances/SV/VSST923.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, MED |

### User Story

As a practice staff, I want high-volume prescription control warn the user, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Verordnung exceeding volume thresholds, when saved, then a Hochvolumen warning is displayed to the user

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/coding_rule`

1. **Prescription validation** -- The `medicine` and `coding_rule` packages provide prescription validation rules.
2. **Gap: High-volume threshold warning** -- The specific Hochvolumen warning when prescriptions exceed volume thresholds needs verification in the prescription validation logic.

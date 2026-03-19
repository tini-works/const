## US-VSST863 — When issuing a repeat prescription (Wiederholungsrezept), the current insurance-specific medication...

| Field | Value |
|-------|-------|
| **ID** | US-VSST863 |
| **Traced from** | [VSST863](../compliances/SV/VSST863.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | MED, KT, VOD |

### User Story

As a practice staff, I want when issuing a repeat prescription (Wiederholungsrezept), the current insurance-specific medication recommendations is retrieved and displayed, checking whether the medication's category has changed and showing substitution options per the interface specification, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a repeat prescription, when issued, then current insurance-specific recommendations are retrieved, category changes are checked, and substitution options are displayed per interface specification

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/hpm_check_history`

1. **Prescription management** -- The `medicine` package handles prescription workflows including repeat prescriptions.
2. **Gap: Repeat prescription HPM category check** -- The specific retrieval of current insurance-specific recommendations during repeat prescription issuance, category change detection, and substitution option display per interface specification is not fully verified.

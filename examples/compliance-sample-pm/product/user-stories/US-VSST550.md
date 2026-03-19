## US-VSST550 — The Vertragssoftware must display the following hint in the context...

| Field | Value |
|-------|-------|
| **ID** | US-VSST550 |
| **Traced from** | [VSST550](../compliances/SV/VSST550.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | MED, KT |

### User Story

As a practice staff, I want the Vertragssoftware display the following hint in the context of insurance-specific medication recommendations: 'Please verify whether the suggested substitution is medically feasible in the specific case regarding indications, dosage, and formulation.', so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given insurance-specific medication recommendations are displayed, when the user views them, then the hint about verifying medical feasibility of substitutions is shown

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/hpm_check_history`

1. **Gap: Substitution feasibility hint** -- The specific hint text 'Please verify whether the suggested substitution is medically feasible...' in the context of insurance-specific medication recommendations is a UI-level requirement. No backend evidence of this specific hint text was found.

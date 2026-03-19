## US-VSST515 — Prescription data transmission prerequisites

| Field | Value |
|-------|-------|
| **ID** | US-VSST515 |
| **Traced from** | [VSST515](../compliances/SV/VSST515.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, UBS |

### User Story

As a practice staff, I want prescription data transmission prerequisites, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given Verordnungsdaten for transmission, when prerequisites are checked, then all required fields and validations must pass before sending

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/erezept`, `api/billing`, `api/pvs_billing`

1. **Prescription data structure** -- The `medicine` and `erezept` packages implement Verordnungsdaten creation with required field validation.
2. **Transmission prerequisites** -- The `billing` and `pvs_billing` packages enforce billing validation rules before transmission.
3. **Gap: Specific prerequisite checklist** -- The exact prerequisite checks before Verordnungsdaten transmission (per AKA specification) need verification against the contract-specific rules in the Selektivvertragsdefinition.

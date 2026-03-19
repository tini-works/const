## US-VSST621 — The Vertragssoftware must prevent issuing an AU or eAU when...

| Field | Value |
|-------|-------|
| **ID** | US-VSST621 |
| **Traced from** | [VSST621](../compliances/SV/VSST621.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware prevent issuing an AU or eAU when the patient's employment status and type are not filled or not current, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a patient with empty or outdated employment data, when an AU or eAU issuance is attempted, then the system blocks issuance until employment data is current

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/eau`, `api/patient_profile`

1. **eAU workflow** -- The `eau` package provides AU/eAU creation with validation.
2. **Gap: Employment data blocking** -- The specific blocking of AU/eAU issuance when employment data is not filled or not current is not verified as a validation rule in the eAU creation flow.

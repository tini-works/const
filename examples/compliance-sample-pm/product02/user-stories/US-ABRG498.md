## US-ABRG498 — Billing data must include the accident indicator (Unfallkennzeichen) when work...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG498 |
| **Traced from** | [ABRG498](../compliances/SV/ABRG498.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want billing data include the accident indicator (Unfallkennzeichen) when work accidents apply, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Behandlungsfall with Arbeitsunfall, when billing is generated, then Unfallkennzeichen is included in the data

### Actual Acceptance Criteria

1. Partially implemented. The encounter model in `backend-core/service/domains/repos/app_core/patient_encounter/encounter_common.d.go` includes accident-related fields. The HPM builder at `backend-core/service/domains/internal/billing/hpm_next_builder/mapper.go` maps encounter data including Unfallkennzeichen to the HPM billing format.

## US-ABRG617 — Substitute doctor services must be correctly attributed while maintaining primary...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG617 |
| **Traced from** | [ABRG617](../compliances/SV/ABRG617.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want substitute doctor services is correctly attributed while maintaining primary care relationship, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Vertreterarzt documenting services, when billing is generated, then services are attributed to the Vertreter while the Stammpraxis relationship is maintained

### Actual Acceptance Criteria

1. Partially implemented. The employee/doctor profile at `backend-core/service/domains/repos/profile/employee/employee.d.go` includes LANR fields for substitute doctors. The billing HPM builder at `backend-core/service/domains/internal/billing/hpm_next_builder/builder.go` maps doctor attribution. The `vert647.validator.go` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/` validates Vertreter-related rules.

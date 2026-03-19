## US-ABRG618 — All billing and prescription data by a substitute physician must...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG618 |
| **Traced from** | [ABRG618](../compliances/SV/ABRG618.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want all billing and prescription data by a substitute physician is transmitted with the substitute's LANR, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given Vertreterarzt billing data, when transmitted, then the Vertreter-LANR is used in all relevant fields

### Actual Acceptance Criteria

1. Partially implemented. The employee profile includes LANR fields in `backend-core/service/domains/repos/profile/employee/employee.d.go`. The HPM builder at `backend-core/service/domains/internal/billing/hpm_next_builder/mapper.go` maps LANR to billing transmissions. The `ContractRules.RequiredInformation` in `backend-core/app/app-core/api/contract/contract.d.go` includes `RequiredLanr` and `RequiredBsnr` flags per service code.

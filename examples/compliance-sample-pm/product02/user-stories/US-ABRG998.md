## US-ABRG998 — System must ensure billing data includes required material cost documentation...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG998 |
| **Traced from** | [ABRG998](../compliances/SV/ABRG998.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want ensure billing data includes required material cost documentation (Sachkosten), so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Leistung with Sachkosten requirement, when material cost data is missing, then validation flags the omission

### Actual Acceptance Criteria

1. Partially implemented. The `catalog_overview` service at `backend-core/service/domains/catalog_overview/service.material-cost.go` handles material cost (Sachkosten) data. The SDEBM catalog additional fields at `backend-core/service/domains/repos/masterdata_repo/sdebm/additional_field/rule_config.go` include Sachkosten-related rules. Full validation that flags missing Sachkosten in billing data needs verification in the timeline validators.

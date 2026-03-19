## US-ALLG1232 — Selective contract definitions must be loadable

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1232 |
| **Traced from** | [ALLG1232](../compliances/SV/ALLG1232.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | VTG |

### User Story

As a practice owner, I want selective contract definitions is loadable, so that general compliance requirements are met.

### Acceptance Criteria

1. Given a Selektivvertragsdefinition file, when import is triggered, then the contract definition is loaded and active

### Actual Acceptance Criteria

| Status | **Implemented** |
|--------|----------------|

1. Selektivvertragsdefinitionen are loaded from embedded XML files via `//go:embed` directives in `backend-core/service/contract/contract/repository.go` (from `contract_data/Selektivvertragsdefinitionen/`) and `backend-core/service/contract/contract/model/aka_loader.go` (AKA XML).
2. Multiple Selektivvertragsdefinitionen XML files exist under `backend-core/service/contract/contract/model/` and are loaded at startup (e.g., TK_HZV, AWH_01, BKK_VAG, SI_IKK_HZV, RV_KBS variants, etc.).
3. Contract definitions are parsed into the `Contract` model and made active for use by the contract service.

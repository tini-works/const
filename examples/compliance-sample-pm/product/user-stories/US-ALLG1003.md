## US-ALLG1003 — The Vertragssoftware must manage Honoraranlage(n) (fee schedules) per contract as...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1003 |
| **Traced from** | [ALLG1003](../compliances/SV/ALLG1003.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want the Vertragssoftware manage Honoraranlage(n) (fee schedules) per contract as defined in the Selektivvertragsdefinitionen, with each individual service assigned to exactly one fee schedule, so that general compliance requirements are met.

### Acceptance Criteria

1. Given Selektivvertragsdefinitionen with Honoraranlagen, when fee schedules are managed, then each service is assigned to exactly one Honoraranlage per contract

### Actual Acceptance Criteria

| Status | **Implemented** |
|--------|----------------|

1. Honoraranlagen (fee schedules) are parsed from Selektivvertragsdefinitionen XML files and managed per contract.
2. The `Contract` model at `backend-core/service/contract/contract/model/contract.go` exposes `GetChargeSystems()`, `GetEffectiveChargeSystem()`, and `GetModuleChargeSystems()` methods.
3. The `GetAllChargeSystems()` method on the contract service returns all charge systems mapped by contract.
4. Each contract's `ContractDefinition` contains `Honoraranlagen` and `Modulvertrag` with their own `Honoraranlagen`, ensuring each service is assigned to exactly one fee schedule per contract.

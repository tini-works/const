## US-VERT1545 — Contract feature gate

| Field | Value |
|-------|-------|
| **ID** | US-VERT1545 |
| **Traced from** | [VERT1545](../compliances/SV/VERT1545.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want contract feature gate, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Vertrag with feature gates, when a gated feature is accessed, then it is only available if the contract supports it


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetContractsHasFunctions` acts as a feature gate by checking `FunctionIds` against contract `ContractFuntions`. `IsPracticeSupportHpmFunction` checks if a practice supports specific HPM functions. `IsPracticeSupportCompliance` verifies compliance support per contract.

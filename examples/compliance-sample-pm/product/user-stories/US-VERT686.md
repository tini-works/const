## US-VERT686 — Contract-specific features must be gated by contract support

| Field | Value |
|-------|-------|
| **ID** | US-VERT686 |
| **Traced from** | [VERT686](../compliances/SV/VERT686.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want contract-specific features is gated by contract support, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Vertrag not supporting a specific feature, when the user attempts to use it, then access is blocked


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetContractsHasFunctions` checks which contracts support specific features (identified by `FunctionIds`). `IsPracticeSupportHpmFunction` verifies if a practice supports a specific HPM function. `ContractFuntions` and `HpmFunctionType` model feature gates per contract.

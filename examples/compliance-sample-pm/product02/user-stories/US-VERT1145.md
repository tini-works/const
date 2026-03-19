## US-VERT1145 — Available contracts must be displayed to user

| Field | Value |
|-------|-------|
| **ID** | US-VERT1145 |
| **Traced from** | [VERT1145](../compliances/SV/VERT1145.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want available contracts is displayed to user, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Praxis with configured Verträge, when the user opens contract view, then all available Selektivverträge are listed


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetContracts` (ContractApp) returns all available `Selektivvertraege` as `ContractMetaData` (contractId, contractName, contractType, chargeSystems, kvRegion). Contracts are loaded from XML Selektivvertragsdefinitionen and served to the user.

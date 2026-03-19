## US-ALLG661 — Each HÄVG contract must be managed internally with a unique...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG661 |
| **Traced from** | [ALLG661](../compliances/SV/ALLG661.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | VTG, VKZ |

### User Story

As a practice owner, I want each HÄVG contract is managed internally with a unique contract ID, so that general compliance requirements are met.

### Acceptance Criteria

1. Given a HÄVG-Vertrag, when imported, then it receives a unique internal Vertrags-ID

### Actual Acceptance Criteria

| Status | **Implemented** |
|--------|----------------|

1. Each HAVG contract is managed with a unique `ContractId` (type alias in `backend-core/service/contract/contract/model/`).
2. The `ContractApp` at `backend-core/app/app-core/api/contract/contract.d.go` exposes RPCs including `GetContracts`, `GetContractsHasFunctions`, with each contract identified by its unique ID (e.g., `AWH_01`, `BKK_BOSCH_BW`, `TK_HZV`).
3. Methods `GetContractDetailById`, `GetContractByIds`, and `GetAllContractIds` in `backend-core/service/contract/contract/service.go` confirm unique contract ID management.

## US-ALLG660 — System must maintain contract-specific cost carrier data from each selective...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG660 |
| **Traced from** | [ALLG660](../compliances/SV/ALLG660.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | KT, VTG |

### User Story

As a practice owner, I want maintain contract-specific cost carrier data from each selective contract definition, so that general compliance requirements are met.

### Acceptance Criteria

1. Given a Selektivvertrag definition, when loaded, then contract-specific Kostenträgerdaten are imported and maintained

### Actual Acceptance Criteria

| Status | **Implemented** |
|--------|----------------|

1. The contract service at `backend-core/service/contract/contract/` loads Selektivvertragsdefinitionen from embedded XML files and parses Kostentrager data from them.
2. AKA XML data files (e.g., `AKA_VSW_HZV_Q1-26-1.xml`) are embedded via `//go:embed` in `backend-core/service/contract/contract/model/aka_loader.go`.
3. Individual Selektivvertragsdefinitionen XML files are loaded from `contract_data/Selektivvertragsdefinitionen/` and contain contract-specific cost carrier (Kostentrager) information.
4. The `FindContractsByIkNumber` method enables lookup of contracts by insurance carrier IK number, confirming cost carrier data is maintained per contract.

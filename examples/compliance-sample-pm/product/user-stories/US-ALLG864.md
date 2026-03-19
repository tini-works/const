## US-ALLG864 — Contract-controlling information must be accessible

| Field | Value |
|-------|-------|
| **ID** | US-ALLG864 |
| **Traced from** | [ALLG864](../compliances/SV/ALLG864.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | VTG |

### User Story

As a practice owner, I want contract-controlling information is accessible, so that general compliance requirements are met.

### Acceptance Criteria

1. Given Vertragssteuerungsinformationen, when requested, then they are accessible to authorized users

### Actual Acceptance Criteria

| Status | **Implemented** |
|--------|----------------|

1. Contract-controlling information (Vertragssteuerungsinformationen) is accessible via authenticated RPCs in the `ContractApp` at `backend-core/app/app-core/api/contract/contract.d.go`.
2. The `GetContracts` and `GetContractsHasFunctions` RPCs are registered with `titan.IsAuthenticated()`, ensuring only authorized users can access contract information.
3. The contract service exposes contract details, attachments, hints, leaflets, fee schedules, and enrollment form data through various service methods.

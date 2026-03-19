## US-ALLG1014 — During initial contract setup, only contracts valid for the practice's...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1014 |
| **Traced from** | [ALLG1014](../compliances/SV/ALLG1014.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want during initial contract setup, only contracts valid for the practice's KV region (by BSNR) is shown first, so that general compliance requirements are met.

### Acceptance Criteria

1. Given initial Vertragseinrichtung, when the contract list is displayed, then only contracts valid for the Praxis KV-Region (BSNR) are shown first

### Actual Acceptance Criteria

| Status | **Partially Implemented** |
|--------|--------------------------|

1. KV region (KvRegion) filtering exists in contract lookup logic, as evidenced by tests in `backend-core/service/contract/contract/service_test.go` that verify contracts are filtered by KvRegion.
2. A BSNR service exists at `backend-core/service/bsnr/` that provides practice BSNR data.
3. The `GetSupportedContracts` method filters contracts, and test cases confirm KvRegion-based filtering works.
4. **Gap**: It is unclear whether the initial contract setup UI specifically shows only KV-region-valid contracts first (as a prioritized display), since this depends on frontend implementation. The backend filtering capability exists.

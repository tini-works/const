## US-ALLG687 — Mandatory audit/billing module must be integrated

| Field | Value |
|-------|-------|
| **ID** | US-ALLG687 |
| **Traced from** | [ALLG687](../compliances/SV/ALLG687.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | PM, PVS |

### User Story

As a practice owner, I want mandatory audit/billing module is integrated, so that general compliance requirements are met.

### Acceptance Criteria

1. Given the PVS, when the audit/billing module is required, then it is integrated and functional

### Actual Acceptance Criteria

| Status | **Not Implemented (as external module)** |
|--------|----------------------------------------|

1. There is no external Prufmodul (audit/billing module) integrated as a separate module.
2. The system has native billing validation logic in `backend-core/service/timeline_validation/` and `backend-core/service/billing_kv/`, but these are built-in services, not an externally integrated Prufmodul.
3. **Gap**: The compliance requirement refers to integrating the mandatory HAVG Prufmodul as an external audit/billing module. The system uses its own billing validation instead.

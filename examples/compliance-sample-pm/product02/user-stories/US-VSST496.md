## US-VSST496 — The Vertragssoftware must mark all transmitted prescription data (Verordnungsdaten) as...

| Field | Value |
|-------|-------|
| **ID** | US-VSST496 |
| **Traced from** | [VSST496](../compliances/SV/VSST496.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware mark all transmitted prescription data (Verordnungsdaten) as billed after successful data transmission, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given successful prescription data transmission, when the process completes, then all transmitted Verordnungen are flagged as 'abgerechnet'

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/billing`, `api/pvs_billing`, `api/billing_edoku`, `api/billing_history`

1. **Billing status flagging** -- The `billing` and `pvs_billing` API packages exist with full billing workflow support (create, validate, submit). The billing pipeline handles Verordnungsdaten within the quarterly billing cycle.
2. **Post-transmission status update** -- The `billing_edoku` package handles eDoku-based billing including transmission state tracking. The `billing_history` package provides audit trail for billing status changes.
3. **Gap: Explicit 'abgerechnet' flag on Verordnungen** -- While billing status tracking exists at the billing-case level, the explicit per-Verordnung 'abgerechnet' flag after successful transmission is not separately verified as a distinct data field. The billing pipeline marks cases as transmitted, but the granular per-prescription flag needs verification.

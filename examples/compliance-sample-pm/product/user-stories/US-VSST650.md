## US-VSST650 — Prescription data transmission

| Field | Value |
|-------|-------|
| **ID** | US-VSST650 |
| **Traced from** | [VSST650](../compliances/SV/VSST650.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, UBS |

### User Story

As a practice staff, I want prescription data transmission, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given Verordnungsdaten ready, when transmission is triggered, then the data is sent via the configured channel

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/billing`, `api/pvs_billing`, `api/billing_kv`

1. **Billing transmission** -- The `billing`, `pvs_billing`, and `billing_kv` packages implement billing data transmission workflows.
2. **Gap: Verordnungsdaten-specific transmission** -- The specific transmission channel and format for prescription data (Verordnungsdaten) within the Selektivvertrag context needs verification.

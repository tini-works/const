## US-ABRD1008 — Post-submission modification of services and diagnoses must be supported for...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1008 |
| **Traced from** | [ABRD1008](../compliances/SV/ABRD1008.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, DX, ABR |

### User Story

As a practice doctor, I want post-submission modification of services and diagnoses is supported for Medi-type contracts, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a submitted Medi-Vertrag Abrechnung, when the user modifies services/diagnoses, then a Korrekturlieferung is generated

### Actual Acceptance Criteria

1. Implemented -- `billing.ReSubmitBillings` / `billing.ReSubmitBilling` support post-submission correction.
2. `pvs_billing.ReopenWholeBilling` reopens completed billing cycles.

## US-ABRD601 — Billing data must be labeled/identified per contract

| Field | Value |
|-------|-------|
| **ID** | US-ABRD601 |
| **Traced from** | [ABRD601](../compliances/SV/ABRD601.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | ABR, VKZ |

### User Story

As a practice doctor, I want billing data is labeled/identified per contract, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given Abrechnungsdaten for a Selektivvertrag, when the data is generated, then it contains the correct Vertragskennzeichen

### Actual Acceptance Criteria

1. The `billing.GetContractTypeByIds` operation retrieves contract type metadata, ensuring billing data is associated with specific contract identifiers.
2. The `billing.SubmitBilling` / `billing.SubmitBillingV2` and `billing.SubmitBillingToHpm` operations handle SV billing submission with contract-specific labeling.
3. The `billing.GetBillableEncounters` operation retrieves encounters filtered by contract context for billing data generation.

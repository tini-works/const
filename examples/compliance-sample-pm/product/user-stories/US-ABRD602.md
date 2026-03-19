## US-ABRD602 — Contract-specific services must be documented

| Field | Value |
|-------|-------|
| **ID** | US-ABRD602 |
| **Traced from** | [ABRD602](../compliances/SV/ABRD602.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, VTG |

### User Story

As a practice doctor, I want contract-specific services is documented, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Selektivvertrag with defined Leistungskatalog, when a service is documented, then only contract-valid services are accepted

### Actual Acceptance Criteria

1. The timeline service provides a validation engine with suggestion rules that enforces contract-specific service code validity during documentation.
2. The `billing.GetBillableEncounters` retrieves encounters scoped to contract context; `billing.TestSubmitBilling` / `billing.ReValidatePatientBillingSubmission` validate against contract rules.
3. The `billing.PreConditionSvBilling` performs pre-condition checks for SV billing.

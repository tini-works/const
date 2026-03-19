## US-ABRG1007 — The Vertragssoftware must always transmit all services (Leistungen) for a...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG1007 |
| **Traced from** | [ABRG1007](../compliances/SV/ABRG1007.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | SVC, BF, ABR |

### User Story

As a practice doctor, I want the Vertragssoftware always transmit all services (Leistungen) for a given billing case (Abrechnungsfall), so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given an Abrechnungsfall with multiple Leistungen, when billing data is transmitted, then all services for that case are included in the transmission without omissions

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.SubmitBillingToHpm` and `BillingApp.SubmitBillingV2` operations in `backend-core/app/app-core/api/billing/billing.d.go` transmit all services for a billing case. The HPM builder at `backend-core/service/domains/internal/billing/hpm_next_builder/builder.go` constructs the complete billing payload including all Leistungen for each Abrechnungsfall. The `BillingApp.GetBillableEncounters` retrieves all billable encounters for transmission.

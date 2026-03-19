## US-ABRG614 — System must provide a control list summarizing billable cases, services,...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG614 |
| **Traced from** | [ABRG614](../compliances/SV/ABRG614.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | KLL, ABR |

### User Story

As a practice doctor, I want provide a control list summarizing billable cases, services, and amounts for pre-submission review, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given billing data ready for submission, when the user requests a Kontrollliste, then a summary with cases, services, and amounts is generated

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.CalculateBillingSummary` operation in `backend-core/app/app-core/api/billing/billing.d.go` returns `CalculateBillingSummaryResponse` summarizing billable cases, services, and amounts. The `BillingKVApp.Troubleshoot` in `backend-core/app/app-core/api/billing_kv/billing_kv.d.go` also returns summary data including `TotalScheins`, `TotalPatients`, and `TotalErrors`.

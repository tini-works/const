## US-ABRG993 — System must provide a summary view aggregating case counts, service...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG993 |
| **Traced from** | [ABRG993](../compliances/SV/ABRG993.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | ABR, QTR |

### User Story

As a practice doctor, I want provide a summary view aggregating case counts, service totals, and financial summaries, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given billing data for a Quartal, when summary is requested, then case counts, Leistungssummen, and financial totals are displayed

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.CalculateBillingSummary` operation in `backend-core/app/app-core/api/billing/billing.d.go` returns `CalculateBillingSummaryResponse` aggregating case counts, service totals, and financial summaries. The `BillingKVApp.Troubleshoot` in `backend-core/app/app-core/api/billing_kv/billing_kv.d.go` also provides summary data including `TotalScheins`, `TotalPatients`, `TotalErrors`, `TotalWarnings`, and `TotalHints`.

## US-ABRG490 — Transmitted billing data must be marked as transmitted

| Field | Value |
|-------|-------|
| **ID** | US-ABRG490 |
| **Traced from** | [ABRG490](../compliances/SV/ABRG490.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | ABR, UBS |

### User Story

As a practice doctor, I want transmitted billing data is marked as transmitted, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given successful Abrechnungsübertragung, when the process completes, then all transmitted records are marked with Übertragungsstatus

### Actual Acceptance Criteria

1. Implemented. The `BillingApp` emits `BillingHistoryChange` events via `BillingNotifier.NotifyBillingHistoryChange` and tracks billing history through `GetBillingHistories` and `GetBillingHistoriesByReferenceId` in `backend-core/app/app-core/api/billing/billing.d.go`. Transmitted records are tracked in `BillingHistoriesResponse`.

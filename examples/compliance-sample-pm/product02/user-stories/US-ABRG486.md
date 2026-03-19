## US-ABRG486 — System must prevent duplicate billing submissions by blocking re-transmission of...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG486 |
| **Traced from** | [ABRG486](../compliances/SV/ABRG486.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want prevent duplicate billing submissions by blocking re-transmission of already-submitted data, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given Abrechnungsdaten already transmitted, when re-submission is attempted, then the system blocks with a duplicate-submission error

### Actual Acceptance Criteria

1. Partially implemented. The `BillingApp.ReSubmitBillings` operation in `backend-core/app/app-core/api/billing/billing.d.go` handles re-submission via `ReBillingSubmissionRequest`, and `BillingHistories` tracking with `GetBillingHistories` and `GetBillingHistoriesByReferenceId` enables detection of already-transmitted data. Explicit duplicate-blocking logic would need verification in the internal billing service.

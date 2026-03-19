## US-ABRG803 — Users must be able to select or deselect specific cases,...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG803 |
| **Traced from** | [ABRG803](../compliances/SV/ABRG803.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want users is able to select or deselect specific cases, contracts, or time periods before submission, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given billing submission preparation, when the user selects/deselects Fälle or Verträge, then only selected items are included in the submission

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.SubmitBillingV2` and `BillingApp.SubmitBillingToHpm` operations in `backend-core/app/app-core/api/billing/billing.d.go` accept `SubmitBillingToHpmRequest` which allows selection of specific billing data. The `BillingKVApp.TroubleshootRequest` in `backend-core/app/app-core/api/billing_kv/billing_kv.d.go` supports filtering by `Quarter`, `Year`, `BSNRId`, `NBSNRIds`, and `ScheinsIdsSkip` for case/contract selection before submission.

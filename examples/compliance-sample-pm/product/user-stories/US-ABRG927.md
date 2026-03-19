## US-ABRG927 — System must allow users to select transmission channel (online/offline)

| Field | Value |
|-------|-------|
| **ID** | US-ABRG927 |
| **Traced from** | [ABRG927](../compliances/SV/ABRG927.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | UBS, ABR |

### User Story

As a practice doctor, I want allow users to select transmission channel (online/offline), so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given billing ready for submission, when the user selects online or offline Übertragungsweg, then the chosen channel is used

### Actual Acceptance Criteria

1. Partially implemented. The `BillingApp.SubmitBillingToHpm` in `backend-core/app/app-core/api/billing/billing.d.go` handles online submission via HPM. The `BillingKVApp.GetEncryptCONFile` in `backend-core/app/app-core/api/billing_kv/billing_kv.d.go` supports encrypted CON file generation for KV billing. However, an explicit user-facing channel selection (online vs. offline Datentraeger) UI control was not found.

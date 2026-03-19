## US-ABRG616 — System must prevent billing of services that fail HPM validation;...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG616 |
| **Traced from** | [ABRG616](../compliances/SV/ABRG616.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want prevent billing of services that fail HPM validation; invalid services is corrected, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given HPM validation returning errors, when the user attempts submission, then billing is blocked until errors are corrected

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.TestSubmitBillings` operation in `backend-core/app/app-core/api/billing/billing.d.go` performs pre-submission HPM validation. The `BillingCaseErrorChange` event system propagates validation errors to the UI. The `BillingKVApp.Troubleshoot` in `backend-core/app/app-core/api/billing_kv/billing_kv.d.go` flags errors per patient and tracks resolution via `ToggleResolveBillingError`, blocking submission until errors are resolved.

## US-ABRG615 — System must integrate with HPM billing validation module (Abrechnungsprüfmodul) to...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG615 |
| **Traced from** | [ABRG615](../compliances/SV/ABRG615.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want integrate with HPM billing validation module (Abrechnungsprüfmodul) to validate data before submission, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given billing data, when HPM Abrechnungsprüfmodul is invoked, then validation results are returned and displayed

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.TestSubmitBillings` and `BillingApp.TestSubmitBilling` operations in `backend-core/app/app-core/api/billing/billing.d.go` invoke HPM validation (Abrechnungspruefmodul) returning `TestBillingSubmissionResponse` with validation results. The `BillingApp.SubmitBillingToHpm` sends data to HPM for validation, and `HandleEventBillingResponse` processes HPM responses.

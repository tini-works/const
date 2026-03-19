## US-ABRG492 — System must log all validation warnings for quality assurance and...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG492 |
| **Traced from** | [ABRG492](../compliances/SV/ABRG492.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want log all validation warnings for quality assurance and audit documentation, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given billing validation producing warnings, when the process completes, then all warnings are persisted in the audit log

### Actual Acceptance Criteria

1. Implemented. The `BillingApp` emits `BillingCaseErrorChange` events via `BillingNotifier.NotifyBillingCaseErrorChange` in `backend-core/app/app-core/api/billing/billing.d.go`. Validation warnings are persisted via `HandleEventBillingCaseErrorChange` subscribing to `TimelineValidationChange` events. The `BillingKVApp.Troubleshoot` operation in `backend-core/app/app-core/api/billing_kv/billing_kv.d.go` provides detailed error/warning counts (`TotalWarnings`, `TotalHints`).

## US-ABRG929 — Offline billing via file-based export

| Field | Value |
|-------|-------|
| **ID** | US-ABRG929 |
| **Traced from** | [ABRG929](../compliances/SV/ABRG929.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | DTR, ABR |

### User Story

As a practice doctor, I want offline billing via file-based export, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given offline billing selected, when export is triggered, then a valid billing file is created for Datenträger transport

### Actual Acceptance Criteria

1. Partially implemented. The `BillingKVApp.GetEncryptCONFile` in `backend-core/app/app-core/api/billing_kv/billing_kv.d.go` generates encrypted CON files for KV offline billing export. The `BillingKVApp.MakeScheinBill` prepares Schein data for billing file generation. Full file-based export to a data carrier for SV contracts was not found.

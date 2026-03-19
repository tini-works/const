## US-ABRG829 — System must warn when KV services are billed for a...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG829 |
| **Traced from** | [ABRG829](../compliances/SV/ABRG829.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | PAT, VTG |

### User Story

As a practice doctor, I want warn when KV services are billed for a patient with active contract participation, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Patient with active Selektivvertrag-Teilnahme, when KV-Leistungen are billed, then a warning about potential duplicate billing is shown

### Actual Acceptance Criteria

1. Partially implemented. The `BillingKVApp.Troubleshoot` in `backend-core/app/app-core/api/billing_kv/billing_kv.d.go` performs KV billing validation with warnings. The timeline validation system has validators for both KV (in `service_code/kv/`) and SV (in `service_code/sv/`) billing. A specific cross-check warning when KV services are billed for a patient with active Selektivvertrag participation would need verification in the KV precondition validators.

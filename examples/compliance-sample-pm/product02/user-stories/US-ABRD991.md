## US-ABRD991 — OPS codes from EBM Annex 2 must be mandatory when...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD991 |
| **Traced from** | [ABRD991](../compliances/SV/ABRD991.md) |
| **Source** | AKA Q1-26-1, KBV EBM |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want oPS codes from EBM Annex 2 is mandatory when applicable, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Leistung requiring OPS per EBM Anhang 2, when no OPS code is documented, then validation reports a mandatory-field error

### Actual Acceptance Criteria

1. Implemented -- `KvServiceIncludedOpsValidator` enforces mandatory OPS fields (5034/5035/5036).
2. Missing OPS errors surfaced via `billing_kv.Troubleshoot`.

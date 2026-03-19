## US-ABRD459 — Referral doctor LANR and BSNR must be required when contract...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD459 |
| **Traced from** | [ABRD459](../compliances/SV/ABRD459.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | ARZ, BST, UBW |

### User Story

As a practice doctor, I want referral doctor LANR and BSNR is required when contract mandates them, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Vertrag requiring Überweiser-LANR/BSNR, when a referral service is documented without them, then validation blocks submission

### Actual Acceptance Criteria

1. The `schein` API handles referral schein creation (`CreateSchein`, `UpdateSchein`) and the `schein.IsValid` operation performs validation on schein data, which can enforce required fields such as LANR and BSNR.
2. The `billing_kv.Troubleshoot` and `billing_kv.GetError` operations detect and surface billing errors including missing referral doctor identifiers before KV submission.

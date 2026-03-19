## US-ABRD969 — System must warn when an acute diagnosis is marked as...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD969 |
| **Traced from** | [ABRD969](../compliances/SV/ABRD969.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | DX |

### User Story

As a practice doctor, I want warn when an acute diagnosis is marked as permanent (implausible documentation), so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given an akute Diagnose being set as Dauerdiagnose, when saved, then a plausibility warning is displayed

### Actual Acceptance Criteria

1. Implemented -- `DiagnoseValidator` checks ABRD969 compliance via `CheckExistAnforderung`.
2. Invoked during `billing_kv.Troubleshoot` and `billing.SubmitBilling`.

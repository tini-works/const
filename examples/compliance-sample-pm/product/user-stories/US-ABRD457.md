## US-ABRD457 — Referral form hint text must be displayed when applicable

| Field | Value |
|-------|-------|
| **ID** | US-ABRD457 |
| **Traced from** | [ABRD457](../compliances/SV/ABRD457.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | FRM, UBW |

### User Story

As a practice doctor, I want referral form hint text is displayed when applicable, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given an Überweisungsschein is being created, when contract rules require hint text, then the hint text is visible before printing

### Actual Acceptance Criteria

1. The `schein` API supports referral schein creation and updates (`CreateSchein`, `UpdateSchein`), but no dedicated endpoint for displaying referral form hint text was found in the billing or schein APIs.
2. Form generation exists via `form.GetForm` and `form.Print` but specific referral hint text rendering is not explicitly exposed as a standalone API operation in the current codebase.

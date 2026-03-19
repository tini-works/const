## US-ABRD607 — Services submitted for billing must be protected from deletion to...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD607 |
| **Traced from** | [ABRD607](../compliances/SV/ABRD607.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, ABR |

### User Story

As a practice doctor, I want services submitted for billing is protected from deletion to maintain audit trail, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Leistung already submitted for Abrechnung, when a user attempts deletion, then deletion is blocked and an audit entry is preserved

### Actual Acceptance Criteria

1. The `schein.MarkBill` and `schein.MarkNotBilled` control billed status, protecting submitted services from modification.
2. The `billing_history.Create` and `billing_history.Search` maintain audit trail for submissions.
3. The timeline service enforces deletion protection for billed services.

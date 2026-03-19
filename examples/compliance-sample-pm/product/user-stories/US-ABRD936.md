## US-ABRD936 — Blank billing codes must be correctly managed based on active/inactive...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD936 |
| **Traced from** | [ABRD936](../compliances/SV/ABRD936.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, ABR |

### User Story

As a practice doctor, I want blank billing codes is correctly managed based on active/inactive status, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Blanko-Abrechnungscode, when its status is inactive, then it cannot be used for billing
2. When active, then it is selectable

### Actual Acceptance Criteria

1. Implemented -- Contract XML definitions drive Blanko code active/inactive status via Selektivvertragsdefinition parsing.
2. The `billing.GetBillableEncounters` and timeline validation enforce contract-scoped service code availability.

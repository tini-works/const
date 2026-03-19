## US-ABRD939 — Blank billing codes must be assigned to the correct fee...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD939 |
| **Traced from** | [ABRD939](../compliances/SV/ABRD939.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, ABR |

### User Story

As a practice doctor, I want blank billing codes is assigned to the correct fee schedule with proper availability when activated, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Blanko-Code activation, when it is assigned to a Gebührenordnung, then it appears in the correct schedule with proper availability dates

### Actual Acceptance Criteria

1. Implemented -- Contract XML assigns Blanko codes to fee schedules via Selektivvertragsdefinition parsing.
2. The `billing.GetContractTypeByIds` provides fee schedule associations.

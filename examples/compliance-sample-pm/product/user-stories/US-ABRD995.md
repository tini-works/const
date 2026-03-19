## US-ABRD995 — Billing justification text must be capturable for services requiring explanation...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD995 |
| **Traced from** | [ABRD995](../compliances/SV/ABRD995.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, ABR |

### User Story

As a practice doctor, I want billing justification text is capturable for services requiring explanation of medical necessity, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Leistung requiring Begründungstext, when no justification is entered, then validation warns before submission

### Actual Acceptance Criteria

1. Implemented -- `FreeText` field and `AdditionalInfoValidator` enforce justification when required by contract.
2. Blocks submission when justification missing.

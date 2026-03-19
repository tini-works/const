## US-ABRD1035 — Additional information fields must be supported per contract

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1035 |
| **Traced from** | [ABRD1035](../compliances/SV/ABRD1035.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | VTG, BF |

### User Story

As a practice doctor, I want additional information fields is supported per contract, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Vertrag defining Zusatzinformationsfelder, when the user opens a Behandlungsfall, then the additional fields are displayed and editable

### Actual Acceptance Criteria

1. Implemented -- `AdditionalInfos` and `AdditionalInfoValidator` enforce contract-defined fields per service code.

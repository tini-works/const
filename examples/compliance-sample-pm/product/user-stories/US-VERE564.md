## US-VERE564 — TE deletion must follow defined rules

| Field | Value |
|-------|-------|
| **ID** | US-VERE564 |
| **Traced from** | [VERE564](../compliances/SV/VERE564.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE |

### User Story

As a patient, I want tE deletion follow defined rules, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a TE, when deletion is attempted, then only TEs in permitted status are deletable; others are blocked

### Actual Acceptance Criteria

1. Implemented -- `enrollment.UpdatePatientEnrollment` supports status-based updates including deletion rules based on enrollment state.

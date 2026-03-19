## US-ABRD605 — Service documentation is only permitted when the patient has active...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD605 |
| **Traced from** | [ABRD605](../compliances/SV/ABRD605.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, PAT, VTG |

### User Story

As a practice doctor, I want service documentation is only permitted when the patient has active contract participation status, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Patient without active Teilnahmestatus, when a Selektivvertrag-Leistung is entered, then the system blocks the entry

### Actual Acceptance Criteria

1. The `billing.GetPatientProfileByIds` retrieves patient participation profiles to verify enrollment status.
2. The `billing.PreConditionSvBilling` enforces pre-conditions including active patient participation.
3. The `billing.SubmitPreParticipateService` handles pre-participation service submission.

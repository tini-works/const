## US-ABRD1681 — FAV service documentation must include real-time online verification of the...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1681 |
| **Traced from** | [ABRD1681](../compliances/SV/ABRD1681.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want fAV service documentation include real-time online verification of the patient's current participation status, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a FAV-Leistung entry, when the system checks Teilnahmestatus online, then a real-time HPM response confirms or denies participation

### Actual Acceptance Criteria

1. Implemented -- `billing.SubmitPreParticipateService` performs real-time HPM check with `PreParticipationValidator`.

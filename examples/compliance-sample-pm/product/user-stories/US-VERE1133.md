## US-VERE1133 — FAV signature requires 1 signature plus TE-Code

| Field | Value |
|-------|-------|
| **ID** | US-VERE1133 |
| **Traced from** | [VERE1133](../compliances/SV/VERE1133.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, TECODE |

### User Story

As a patient, I want fAV signature requires 1 signature plus TE-Code, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a FAV-Teilnahmeerklärung, when submitted, then 1 Unterschrift and a TE-Code are required

### Actual Acceptance Criteria

1. Implemented -- `enrollment.SendParticipation` submits enrollment.
2. `enrollment.ActionOnFavContract` and `enrollment.ActionOnFavContractGroup` handle FAV-specific actions.

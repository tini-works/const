## US-VERE558 — HZV signature requires 2 signatures plus TE-Code

| Field | Value |
|-------|-------|
| **ID** | US-VERE558 |
| **Traced from** | [VERE558](../compliances/SV/VERE558.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, TECODE |

### User Story

As a patient, I want hZV signature requires 2 signatures plus TE-Code, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given an HZV-Teilnahmeerklärung, when submitted, then 2 Unterschriften and a TE-Code are required

### Actual Acceptance Criteria

1. Implemented -- `enrollment.SendParticipation` submits enrollment to HPM.
2. `enrollment.ActionOnHzvContract` performs HZV contract actions.
3. Open API `/enrollment/hzv-contract/action` exposes this externally.

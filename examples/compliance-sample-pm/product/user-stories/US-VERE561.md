## US-VERE561 — TE transmission must be executable

| Field | Value |
|-------|-------|
| **ID** | US-VERE561 |
| **Traced from** | [VERE561](../compliances/SV/VERE561.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want tE transmission is executable, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a TE with all prerequisites met, when transmission is triggered, then the TE is sent to HPM and status is updated

### Actual Acceptance Criteria

1. Implemented -- `enrollment.SendParticipation` submits enrollment to HPM.
2. `enrollment.ActionOnHzvContract` and `enrollment.ActionOnFavContract` / `ActionOnFavContractGroup` handle contract-specific actions.

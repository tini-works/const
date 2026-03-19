## US-VERE1682 — FAV auto-activation must occur on transmission

| Field | Value |
|-------|-------|
| **ID** | US-VERE1682 |
| **Traced from** | [VERE1682](../compliances/SV/VERE1682.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want fAV auto-activation occur on transmission, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a FAV-TE transmitted, when transmission succeeds, then the Teilnahme is auto-activated

### Actual Acceptance Criteria

1. Implemented -- `enrollment.ActionOnFavContract` and `enrollment.ActionOnFavContractGroup` handle FAV contract lifecycle.
2. `enrollment.SendParticipation` submits to HPM.

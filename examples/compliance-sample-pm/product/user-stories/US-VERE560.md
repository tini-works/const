## US-VERE560 — Transmission prerequisites must be met before TE can be sent

| Field | Value |
|-------|-------|
| **ID** | US-VERE560 |
| **Traced from** | [VERE560](../compliances/SV/VERE560.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want transmission prerequisites is met before TE can be sent, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a TE for transmission, when prerequisites are unmet, then transmission is blocked with a checklist of missing items

### Actual Acceptance Criteria

1. Implemented -- `enrollment.CheckParticipation` verifies patient eligibility.
2. `enrollment.CheckHpmServiceConnection` tests HPM connectivity.
3. `enrollment.SendParticipation` submits verified enrollments.

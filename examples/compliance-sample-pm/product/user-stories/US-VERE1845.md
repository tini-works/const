## US-VERE1845 — Warning must be displayed for missing therapy/diagnosis data

| Field | Value |
|-------|-------|
| **ID** | US-VERE1845 |
| **Traced from** | [VERE1845](../compliances/SV/VERE1845.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, DX |

### User Story

As a patient, I want warning is displayed for missing therapy/diagnosis data, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a TE with missing Therapie/Diagnose data, when transmission is attempted, then a warning about missing data is displayed

### Actual Acceptance Criteria

1. Implemented -- `enrollment.CheckParticipation` verifies eligibility.
2. `enrollment.SendParticipation` submits enrollment.
3. `enrollment.Prescribe` and `form.PrescribeV2` handle form generation.

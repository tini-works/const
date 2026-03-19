## US-VERE1881 — TE identifier must be persisted

| Field | Value |
|-------|-------|
| **ID** | US-VERE1881 |
| **Traced from** | [VERE1881](../compliances/SV/VERE1881.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want tE identifier is persisted, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a TE created, when saved, then a unique TE-Kennung is generated and persisted

### Actual Acceptance Criteria

1. Implemented -- `enrollment.CreatePatientEnrollment` creates enrollment.
2. `enrollment.GetPatientEnrollment` retrieves enrollment data.

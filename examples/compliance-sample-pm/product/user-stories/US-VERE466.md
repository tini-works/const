## US-VERE466 — TE must be saveable for current patient

| Field | Value |
|-------|-------|
| **ID** | US-VERE466 |
| **Traced from** | [VERE466](../compliances/SV/VERE466.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want tE is saveable for current patient, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a Teilnahmeerklärung for the current Patient, when saved, then it is persisted and retrievable

### Actual Acceptance Criteria

1. Implemented -- `enrollment.CreatePatientEnrollment` creates enrollment records; `enrollment.GetPatientEnrollment` retrieves them.
2. `enrollment.UpdatePatientEnrollment` modifies enrollment data.
3. `enrollment.SaveOfflineEnrollment` supports offline enrollment scenarios.

## US-VERE1906 — Enrollment overview lists

| Field | Value |
|-------|-------|
| **ID** | US-VERE1906 |
| **Traced from** | [VERE1906](../compliances/SV/VERE1906.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, KLL |

### User Story

As a patient, I want enrollment overview lists, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given TEs in the system, when the user opens the overview, then filterable lists of all TEs with status are available

### Actual Acceptance Criteria

1. Implemented -- `enrollment.GetPatientEnrollment` and `enrollment.GetPatientContractGroups` provide enrollment data.
2. `patient_participation.GetPatientParticipation` and `patient_participation.CheckPatientParticipation` verify participation.
3. `enrollment.GetContractsDoctors` retrieves participating doctors.

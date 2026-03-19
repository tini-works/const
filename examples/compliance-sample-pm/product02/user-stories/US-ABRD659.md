## US-ABRD659 — Patient-related documentation must be maintained

| Field | Value |
|-------|-------|
| **ID** | US-ABRD659 |
| **Traced from** | [ABRD659](../compliances/SV/ABRD659.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want patient-related documentation is maintained, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Behandlungsfall, when services are documented, then patient-related documentation is persisted and retrievable

### Actual Acceptance Criteria

1. The timeline service provides full CRUD for diagnoses, services, and procedures with quarter grouping.
2. The `billing_patient.GetBillingPatient` and `billing_patient.GetBillingPatientPrintContent` provide patient billing documentation.
3. The `billing_history.Create` and `billing_history.Search` maintain searchable billing history.
4. The `billing_patient.PrintBillingPatient` supports printing.

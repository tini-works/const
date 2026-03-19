## US-ABRG664 — System must warn when billing services older than 4 quarters...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG664 |
| **Traced from** | [ABRG664](../compliances/SV/ABRG664.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E2: Billing Submission](../epics/E2-billing-submission.md) |
| **Data Entity** | SVC, QTR |

### User Story

As a practice doctor, I want warn when billing services older than 4 quarters (beyond late-submission window), so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given Leistungen older than 4 Quartale, when billing is attempted, then a Nachreichungsfrist warning is displayed

### Actual Acceptance Criteria

1. Implemented. A dedicated `ABRG664Validator` exists at `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/abrg664/validator.go`. It uses `YearQuarter` to calculate quarter offsets and warns when billing services exceed the late-submission window (4 quarters / Nachreichungsfrist).

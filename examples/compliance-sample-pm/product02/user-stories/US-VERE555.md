## US-VERE555 — Enrollment declaration printing

| Field | Value |
|-------|-------|
| **ID** | US-VERE555 |
| **Traced from** | [VERE555](../compliances/SV/VERE555.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want enrollment declaration printing, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a Teilnahmeerklärung, when print is requested, then the document is printed correctly

### Actual Acceptance Criteria

1. Implemented -- `enrollment.PrintForm` and `enrollment.PrintMutipleForms` produce contract enrollment forms.
2. `form.Print` and `form.PrintPlainPdf` generate PDF output.

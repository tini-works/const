## US-VERE465 — Enrollment declaration full print

| Field | Value |
|-------|-------|
| **ID** | US-VERE465 |
| **Traced from** | [VERE465](../compliances/SV/VERE465.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, PAT |

### User Story

As a patient, I want enrollment declaration full print, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a Teilnahmeerklärung, when full print is requested, then the complete TE document is printed

### Actual Acceptance Criteria

1. Implemented -- `enrollment.PrintForm` and `enrollment.PrintMutipleForms` support form printing per contract template.
2. `form.Print` and `form.PrintPlainPdf` generate PDF output.

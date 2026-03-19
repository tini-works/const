## US-VERE450 — Enrollment receipt must be printable (DIN A6)

| Field | Value |
|-------|-------|
| **ID** | US-VERE450 |
| **Traced from** | [VERE450](../compliances/SV/VERE450.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TE, PAT |

### User Story

As a patient, I want enrollment receipt is printable (DIN A6), so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a completed Teilnahmeerklärung, when the user prints the receipt, then a DIN-A6 Empfangsbestätigung is generated

### Actual Acceptance Criteria

1. Implemented -- `enrollment.PrintForm` and `enrollment.PrintMutipleForms` generate printable enrollment forms.
2. `form.Print` and `form.PrintPlainPdf` produce PDF output for enrollment documents.

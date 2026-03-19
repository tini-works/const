## US-VERE1239 — FAV enrollment declaration full print

| Field | Value |
|-------|-------|
| **ID** | US-VERE1239 |
| **Traced from** | [VERE1239](../compliances/SV/VERE1239.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want fAV enrollment declaration full print, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a FAV-Teilnahmeerklärung, when full print is requested, then the FAV-specific TE document is printed

### Actual Acceptance Criteria

1. Implemented -- `enrollment.PrintForm` and `enrollment.PrintMutipleForms` generate enrollment forms.
2. `form.Print` and `form.PrintPlainPdf` produce PDF output.

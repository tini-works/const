## US-ABRD1449 — A warning must display if no physician-patient contact code is...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1449 |
| **Traced from** | [ABRD1449](../compliances/SV/ABRD1449.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, BF |

### User Story

As a practice doctor, I want a warning display if no physician-patient contact code is documented in a FAV billing case, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a FAV-Abrechnungsfall without Arzt-Patienten-Kontakt code, when Abrechnung is triggered, then a warning is displayed

### Actual Acceptance Criteria

1. Implemented -- validated during `validateSubmissionRequests` in the billing pipeline.

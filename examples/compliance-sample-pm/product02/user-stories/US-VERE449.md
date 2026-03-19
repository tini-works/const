## US-VERE449 — Enrollment declaration hint must be shown (DIN A4)

| Field | Value |
|-------|-------|
| **ID** | US-VERE449 |
| **Traced from** | [VERE449](../compliances/SV/VERE449.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want enrollment declaration hint is shown (DIN A4), so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given TE-Erstellung for a HZV-Vertrag, when the DIN-A4 Teilnahmeerklärung is shown, then the hint text is visible

### Actual Acceptance Criteria

1. Implemented -- `enrollment.PreviewForm` and `enrollment.GetPreviewFormUrl` generate enrollment form previews including hint text display.
2. `enrollment.PrintForm` produces the DIN-A4 Teilnahmeerklaerung with hint text visible.

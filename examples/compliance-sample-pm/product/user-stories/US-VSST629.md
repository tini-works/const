## US-VSST629 — When prescribing a steuerbare Hilfsmittel, the Vertragssoftware must check whether...

| Field | Value |
|-------|-------|
| **ID** | US-VSST629 |
| **Traced from** | [VSST629](../compliances/SV/VSST629.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want when prescribing a steuerbare Hilfsmittel, the Vertragssoftware check whether a questionnaire (Fragebogen) is required by verifying whether the FRAGEBOGEN column in the steuerbare Hilfsmittel list is non-empty, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a steuerbare Hilfsmittel, when its FRAGEBOGEN column is non-empty, then the system requires the user to fill out the questionnaire

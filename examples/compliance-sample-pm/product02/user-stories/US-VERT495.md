## US-VERT495 — When requesting HzV participation, the Vertragssoftware must verify the patient's...

| Field | Value |
|-------|-------|
| **ID** | US-VERT495 |
| **Traced from** | [VERT495](../compliances/SV/VERT495.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want when requesting HzV participation, the Vertragssoftware verify the patient's current HzV participation status online via the Pruef- und Abrechnungsmodul and display appropriate messages depending on whether participation already exists or not, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given HzV participation is requested, when the HPM returns no active participation, then the message 'Der Patient ist derzeit kein aktiver Vertragsteilnehmer' is shown
2. Given active participation exists, then the appropriate status message is displayed


### Actual Acceptance Criteria

**Status: Partially Implemented**

1. **Partially met.** `CheckParticipation` queries HPM and returns status with `Reason` and `ErrorMessages`. The specific German message 'Der Patient ist derzeit kein aktiver Vertragsteilnehmer' is not confirmed in the codebase -- the message text likely comes from HPM response or frontend localization.
2. **Met.** When active participation exists, the status and reason are returned and displayed.

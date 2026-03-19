## US-VERT581 — When requesting FaV participation, the Vertragssoftware must verify the patient's...

| Field | Value |
|-------|-------|
| **ID** | US-VERT581 |
| **Traced from** | [VERT581](../compliances/SV/VERT581.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, TNV, PM |

### User Story

As a practice owner, I want when requesting FaV participation, the Vertragssoftware verify the patient's current FaV participation status online via the Pruef- und Abrechnungsmodul and display appropriate messages depending on whether participation already exists or not, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given FaV participation is requested, when the HPM returns no active participation, then the message 'Der Patient ist derzeit kein aktiver Vertragsteilnehmer' is shown
2. Given active participation exists, then the appropriate status message is displayed


### Actual Acceptance Criteria

**Status: Partially Implemented**

1. **Partially met.** `ActionOnFavContract` and FAV-specific enrollment flows exist in `service_fav.go`. `CheckParticipation` can query FAV participation via HPM. However, the specific German hint message is not confirmed in backend code.
2. **Met.** Active FAV participation status is returned and displayed via `CheckParticipationResponse`.

## US-VERT1848 — The Vertragssoftware must use the patient's eGK-Nummer (persoenliche Versichertennummer der...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1848 |
| **Traced from** | [VERT1848](../compliances/SV/VERT1848.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want the Vertragssoftware use the patient's eGK-Nummer (persoenliche Versichertennummer der elektronischen Gesundheitskarte) for participation status queries; legacy Versichertennummern not be used, and if no eGK-Nummer is available, participation status not be determined, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a patient with an eGK-Nummer, when participation status is queried, then the eGK-Nummer is used
2. Given a patient without eGK-Nummer, then the status query is blocked
3. Given a legacy Versichertennummer, then it is not accepted for status queries


### Actual Acceptance Criteria

**Status: Partially Implemented**

1. **Met.** `CheckParticipationRequest` uses `InsuranceNumber` (string field) for participation queries, which maps to the eGK-Nummer.
2. **Not confirmed.** No explicit blocking logic found in the backend that prevents status queries when no eGK-Nummer is available. This may be enforced at the frontend or HPM level.
3. **Not confirmed.** No explicit rejection of legacy Versichertennummern found in the backend validation logic.

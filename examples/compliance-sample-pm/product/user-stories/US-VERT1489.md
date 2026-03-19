## US-VERT1489 — The Vertragssoftware must provide a list of all patients with...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1489 |
| **Traced from** | [VERT1489](../compliances/SV/VERT1489.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, TNV, VTG |

### User Story

As a practice owner, I want the Vertragssoftware provide a list of all patients with HZV contract status (Beantragt, Aktiviert, or Beendet) per active HZV contract, showing at minimum: patient name, Versichertennummer, birth date, status, dates, and Betreuarzt, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given an active HZV contract, when the user opens the patient list, then all patients with status Beantragt/Aktiviert/Beendet are shown with name, Versichertennummer, birth date, status, dates, and Betreuarzt


### Actual Acceptance Criteria

**Status: Partially Implemented**

1. **Partially met.** `GetPatientContractGroups` returns contract groups per patient. `GetPatientParticipation` returns participation data. However, a unified list showing all patients per HZV contract with status (Beantragt/Aktiviert/Beendet), name, Versichertennummer, birth date, dates, and Betreuarzt is not available as a single endpoint -- it requires combining data from multiple services.

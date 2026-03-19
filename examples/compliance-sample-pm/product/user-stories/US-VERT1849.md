## US-VERT1849 — If the participation status cannot be determined because the patient...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1849 |
| **Traced from** | [VERT1849](../compliances/SV/VERT1849.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, EGK, TNV |

### User Story

As a practice owner, I want if the participation status cannot be determined because the patient has no valid eGK-Nummer, the Vertragssoftware display: 'The participation status cannot be determined because no valid eGK Versichertennummer is available.' This hint only appear when the status is actively being determined, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a patient without eGK-Nummer, when participation status is being determined, then the hint 'Der Teilnahmestatus kann nicht ermittelt werden, da keine gueltige eGK-Versichertennummer vorliegt' is displayed
2. Given the status is not being actively queried, then the hint does not appear


### Actual Acceptance Criteria

**Status: Not Implemented**

1. **Not met.** No backend logic found that generates the specific hint message 'Der Teilnahmestatus kann nicht ermittelt werden, da keine gueltige eGK-Versichertennummer vorliegt' when a patient lacks an eGK-Nummer.
2. **N/A.** Depends on criterion 1.

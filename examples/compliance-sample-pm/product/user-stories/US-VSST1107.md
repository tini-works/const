## US-VSST1107 — The Vertragssoftware must enable launching the PraCMan-Cockpit for contract participants...

| Field | Value |
|-------|-------|
| **ID** | US-VSST1107 |
| **Traced from** | [VSST1107](../compliances/SV/VSST1107.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware enable launching the PraCMan-Cockpit for contract participants and pass parameters per the AKA-Basisdatei interface specification, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a contract participant, when the user launches PraCMan-Cockpit, then the software passes the required parameters per AKA interface specification

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/enrollment`, `api/patient_participation`, `api/settings`

1. **Contract participant access** -- The `enrollment` and `patient_participation` packages identify contract participants.
2. **Gap: PraCMan-Cockpit launch with parameters** -- The specific launching of PraCMan-Cockpit with AKA interface specification parameters for contract participants is not verified.

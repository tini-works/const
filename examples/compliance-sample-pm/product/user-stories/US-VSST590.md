## US-VSST590 — Insurance contact data for care coordination

| Field | Value |
|-------|-------|
| **ID** | US-VSST590 |
| **Traced from** | [VSST590](../compliances/SV/VSST590.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | KT, PAT |

### User Story

As a practice staff, I want insurance contact data for care coordination, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Patient with Selektivvertrag, when care coordination is needed, then insurance contact data (Ansprechpartner, Telefon) is available

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/enrollment`, `api/patient_participation`, `service/insurance`, `service/contract`

1. **Contract participant management** -- The `enrollment` and `patient_participation` packages manage Selektivvertrag participants.
2. **Insurance data** -- The `insurance` domain service provides insurance contact data.
3. **Gap: Care coordination contact display** -- The specific display of insurance Ansprechpartner and Telefon for care coordination within the Selektivvertrag context needs verification.

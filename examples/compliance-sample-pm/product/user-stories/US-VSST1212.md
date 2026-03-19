## US-VSST1212 — For contract participants aged 12 to 17, deviating from SGB...

| Field | Value |
|-------|-------|
| **ID** | US-VSST1212 |
| **Traced from** | [VSST1212](../compliances/SV/VSST1212.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | PAT, MED, VOD |

### User Story

As a practice staff, I want for contract participants aged 12 to 17, deviating from SGB V section 34(1), non-prescription medications (OTC) automatically be prescribed on the Kassenrezept (Muster 16) under AM-RL Anlage II/III and Negativliste rules; manual change of prescription type remain possible, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a participant aged 12-17, when OTC medication is prescribed, then it is automatically placed on Muster 16 (Kassenrezept)
2. Given manual override needed, then the prescription type can be changed

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/form`, `api/patient_profile`

1. **Prescription type handling** -- The `medicine` and `form` packages handle prescription forms including Muster 16 (Kassenrezept).
2. **Patient age** -- The `patient_profile` package provides patient age.
3. **Gap: Age 12-17 automatic Kassenrezept for OTC** -- The specific automatic placement of OTC medications on Muster 16 for contract participants aged 12-17, with manual override capability, needs verification.

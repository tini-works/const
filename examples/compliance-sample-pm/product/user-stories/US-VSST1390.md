## US-VSST1390 — Preventive colonoscopy hint

| Field | Value |
|-------|-------|
| **ID** | US-VSST1390 |
| **Traced from** | [VSST1390](../compliances/SV/VSST1390.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | PAT, SVC |

### User Story

As a practice staff, I want preventive colonoscopy hint, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Patient eligible for Vorsorge-Koloskopie, when the patient record is opened, then a reminder hint is displayed

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/patient_profile`, `api/patient_sidebar`

1. **Patient age and alerts** -- The `patient_profile` and `patient_sidebar` packages provide patient context data.
2. **Gap: Colonoscopy reminder** -- The specific preventive colonoscopy hint display based on patient eligibility (age criteria) when the patient record is opened is not verified.

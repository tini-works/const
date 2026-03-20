# UnMatching: patient_settings

## File
`backend-core/app/app-core/api/patient_settings/`

## Analysis
- **What this code does**: Manages per-patient, per-quarter settings for the practice management system. Settings include favorite contract online-check preferences per doctor, HZV informed status, whether takeover diagnose was opened, and hide-confirm-missing-ED preferences. Provides save and get operations keyed by patient ID with year/quarter granularity.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-PATIENT_SETTINGS — Per-Patient Quarterly Settings Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-PATIENT_SETTINGS |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E3=Patient Management |
| **Data Entity** | PatientSettings, DoctorContract, Patient |

### User Story
As a physician, I want to manage per-patient settings on a quarterly basis, including favorite contract online-check preferences, HZV informed status, and takeover diagnose flags, so that patient-specific workflow preferences persist across sessions within each billing quarter.

### Acceptance Criteria
1. Given a patient ID and quarterly settings data, when the user saves settings, then the system stores the settings keyed by patient ID, year, and quarter
2. Given a patient ID, when the user retrieves settings, then the system returns all quarterly settings for that patient
3. Given settings include favorite contract online-check preferences per doctor, when saved, then the doctor-contract associations are correctly persisted
4. Given HZV informed status or hide-confirm-missing-ED preferences as key-value maps, when saved, then the map entries are correctly stored and retrievable

### Technical Notes
- Source: `backend-core/app/app-core/api/patient_settings/`
- Key functions: SaveSettings, GetSettings
- Integration points: Settings include references to contract IDs and doctor IDs; scoped by year/quarter granularity

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 1.8 HZV/FAV Participation Management | [`compliances/phase-1.8-hzv-fav-participation-management.md`](../../compliances/phase-1.8-hzv-fav-participation-management.md) | [VERT649](../compliances/SV/VERT649.md) |

### Compliance Mapping

#### 1.8 HZV/FAV Participation Management
**Source**: [`compliances/phase-1.8-hzv-fav-participation-management.md`](../../compliances/phase-1.8-hzv-fav-participation-management.md)

**Related Requirements**:
- "The contract software must alert the user when opening a patient record if the patient's insurance has changed since the last visit. This check enables timely re-enrollment or participation adjustment for HZV/FAV contracts."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC3: favorite contract online-check preferences per doctor | [VERT649](../compliances/SV/VERT649.md): insurance change check enabling timely re-enrollment for HZV/FAV contracts |
| AC4: HZV informed status stored and retrievable | [VERT649](../compliances/SV/VERT649.md): alert user about insurance changes for HZV/FAV participation adjustment |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix

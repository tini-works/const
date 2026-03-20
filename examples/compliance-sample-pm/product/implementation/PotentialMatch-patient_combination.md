# UnMatching: patient_combination

## File
`backend-core/app/app-core/api/patient_combination/`

## Analysis
- **What this code does**: Provides patient record merging functionality. Exposes a single endpoint (CombinePatients) that takes a target patient ID and a list of duplicated patient IDs, merging the duplicate records into the target patient. This is used to resolve duplicate patient entries in the system.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-PATIENT_COMBINATION — Patient Record Merging

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-PATIENT_COMBINATION |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E3=Patient Management |
| **Data Entity** | Patient |

### User Story
As a medical practice staff member, I want to merge duplicate patient records into a single target patient, so that all clinical data, billing history, and documentation are consolidated under one unified patient profile.

### Acceptance Criteria
1. Given a target patient ID and a list of duplicate patient IDs, when the user initiates the combine operation, then the system merges all data from the duplicate patients into the target patient
2. Given the combine operation completes, when the merge is successful, then duplicate patient records are consolidated and no data is lost
3. Given invalid or missing patient IDs, when the user attempts to combine, then the system returns a validation error (targetPatientId and duplicatedPatientIds are required)

### Technical Notes
- Source: `backend-core/app/app-core/api/patient_combination/`
- Key functions: CombinePatients
- Integration points: Operates across all patient-linked data domains; requires CARE_PROVIDER_MEMBER role

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 1.3 Patient Matching & Insurance Changes | [`compliances/phase-1.3-patient-matching-insurance-changes.md`](../../compliances/phase-1.3-patient-matching-insurance-changes.md) | KP2-300 |

### Compliance Mapping

#### 1.3 Patient Matching & Insurance Changes
**Source**: [`compliances/phase-1.3-patient-matching-insurance-changes.md`](../../compliances/phase-1.3-patient-matching-insurance-changes.md)

**Related Requirements**:
- "The software must ensure correct patient identification when reading an insurance card by matching against already stored patient data. The system must prevent creation of duplicate patient records and avoid unintentional overwriting of existing patient data. When a match or near-match is found, the user must be presented with the comparison and asked to confirm the action."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: merge duplicate patients into target patient | KP2-300: prevent creation of duplicate patient records |
| AC2: duplicate records consolidated, no data lost | KP2-300: avoid unintentional overwriting of existing patient data |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix

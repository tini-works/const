# UnMatching: service_patient_combination

## File
`backend-core/service/patient_combination/`

## Analysis
- **What this code does**: Provides patient combination (merge/deduplication) functionality. Contains test infrastructure for finding and combining duplicate patient records based on profile matching criteria. Uses a finder component to identify potential duplicates and a combinator component to merge them. The package currently contains only test code.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E3=Patient Management

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-PATIENT-COMBINATION — Patient Duplicate Detection and Merge

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-PATIENT-COMBINATION |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E3=Patient Management |
| **Data Entity** | PatientProfile, ScheinRepo |

### User Story
As a practice administrator, I want to find and merge duplicate patient records based on matching first name, last name, and date of birth, so that patient data remains consistent and free of duplicates across the practice.

### Acceptance Criteria
1. Given a list of patient IDs, when `FindDuplicatePatients` is called, then patients with matching first name, last name, and date of birth are grouped together
2. Given a target patient and a list of duplicate patient IDs, when `Combine` is called, then all related records (scheins, encounters, etc.) are reassigned to the target patient using a MongoDB transaction
3. Given duplicate patients with different insurance types (KV vs. private), when they are evaluated, then they are correctly identified as separate patients
4. Given the merge operation, when it completes, then the duplicate patient records are deactivated and the target patient retains all consolidated data

### Technical Notes
- Source: `backend-core/service/patient_combination/`
- Key functions: Finder.FindDuplicatePatients (groups by name+DOB), Combinator.Combine (merges records in transaction)
- Integration points: patient_profile repo, schein_repo, patient_service (status management), MongoDB transactions

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
- "The software must ensure correct patient identification when reading an insurance card by matching against already stored patient data. The system must prevent creation of duplicate patient records and avoid unintentional overwriting of existing patient data. When a match or near-match is found, the user must be presented with the comparison and asked to confirm the action." (KP2-300)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a list of patient IDs, when FindDuplicatePatients is called, then patients with matching first name, last name, and date of birth are grouped together | KP2-300: "matching against already stored patient data. The system must prevent creation of duplicate patient records" |
| AC2: Given a target patient and a list of duplicate patient IDs, when Combine is called, then all related records are reassigned to the target patient | KP2-300: "avoid unintentional overwriting of existing patient data" |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix

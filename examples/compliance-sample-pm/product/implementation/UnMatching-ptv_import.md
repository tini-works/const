# UnMatching: ptv_import

## File
`backend-core/app/app-core/api/ptv_import/`

## Analysis
- **What this code does**: Handles PTV (Pruefungstheoretische Verwaltung / participant data) import operations for selective healthcare contracts. Supports importing test data, retrieving PTV codes and contracts by doctor, fetching participants by doctor, bulk-importing participants, and viewing PTV import history. This is used for onboarding patient enrollment data from external contract management systems.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-PTV_IMPORT — PTV Participant Data Import for Selective Contracts

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-PTV_IMPORT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E2 Contract Management |
| **Data Entity** | PtvImport, PtvContract, PtvParticipant, PtvImportHistory |

### User Story
As a practice staff member, I want to import PTV participant enrollment data from external selective healthcare contract systems, so that patient participation records are onboarded into the practice management system for HZV/FAV contract processing.

### Acceptance Criteria
1. Given a care provider member, when they request PTV codes by doctor, then the available PTV import codes for that doctor are returned
2. Given a care provider member, when they request contracts by doctor, then the PTV contracts associated with that doctor are returned
3. Given a doctor selection, when the user requests participants by doctor, then the list of importable participants is returned
4. Given selected participants, when the user triggers bulk import, then the participants are imported into the system
5. Given completed imports, when the user requests import history, then a paginated list of past PTV imports is returned
6. Given a test environment, when ImportTestData is called, then test PTV data is seeded for development purposes

### Technical Notes
- Source: `backend-core/app/app-core/api/ptv_import/`
- Key functions: ImportTestData, GetCodeByDoctor, GetContractByDoctor, GetParticipantsByDoctor, ImportParticipants, GetListPtvImportHistory
- Integration points: `service/domains/ptv_import/common`
- All endpoints require CARE_PROVIDER_MEMBER role

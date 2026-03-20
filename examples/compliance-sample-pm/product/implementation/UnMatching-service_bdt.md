# UnMatching: service_bdt

## File
`backend-core/service/bdt/`

## Analysis
- **What this code does**: Provides BDT (Behandlungsdatentransfer - Treatment Data Transfer) file processing for importing and exporting patient and billing data in the xDT format family. Handles BDT context management, document management upload, patient finding, form mapping, and service-level orchestration for data exchange with external systems. A substantial module with models, constants, utilities, and tests.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SERVICE_BDT — BDT Treatment Data Transfer Import/Export

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SERVICE_BDT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | BdtLogEntity, DataContext, PatientData, Schein, PrivateSchein, BGSchein, Treatment, BesaPractice, AddressMasterData |

### User Story
As a care provider member, I want to import patient and billing data from BDT (Behandlungsdatentransfer) files in xDT format, so that data from external practice management systems can be migrated into the current system including patients, scheins, treatments, diagnoses, prescriptions, and forms.

### Acceptance Criteria
1. Given a BDT file uploaded to MinIO, when the import process is initiated with a file name, then the file is extracted, parsed, and processed into the system with a BdtLogEntity tracking progress
2. Given BDT data containing patient records, when patients are imported, then new patient profiles are created or existing ones are matched via the patient finder
3. Given BDT data containing schein records (KV, private, BG), when scheins are imported, then the corresponding schein types are created with associated diagnoses, services, and timeline entries
4. Given BDT data containing treatment data, when treatments are imported, then diagnoses, services, notes, prescriptions, forms, and document management entries are created as timeline entities
5. Given BDT data containing practice information (BesaPractice), when employee data is imported, then employees and their contracts are updated
6. Given LDT lab result data embedded in BDT, when extracted, then lab results and parameters are imported into the document management system
7. Given an import error occurs, when the error is logged, then it is uploaded to MinIO for review

### Technical Notes
- Source: `backend-core/service/bdt/`
- Key functions: Import, HandleImportPatient, ExtractLdtResultFromBdt, CreateTimelineForms, UploadErrorLog, Remove
- Integration points: PatientProfileBff, ScheinRepo, MinIO (file storage), xDT/BDT parser, timeline repositories (diagnoses, services, notes, prescriptions, forms, DM, Heimi, GOA, UV-GOA), contract service, private billing, BG billing, catalog services (SDAV, GOA, UV-GOA, BG insurance), document management, employee management, HeimiRepo, action chain repo
- This is a substantial module (~4000+ lines) handling the complete BDT data migration pipeline

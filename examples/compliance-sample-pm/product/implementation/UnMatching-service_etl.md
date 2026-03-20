# UnMatching: service_etl

## File
`backend-core/service/etl/`

## Analysis
- **What this code does**: Provides an ETL (Extract, Transform, Load) service that migrates data between PostgreSQL and MongoDB. Runs as a standalone process that executes data transformation and then exits. Used for data migration and synchronization tasks.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] This is infrastructure/utility code (no story needed)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-ETL — Data Migration from PostgreSQL to MongoDB

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-ETL |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | Employee, Patient, Schein, Timeline, DoctorParticipate, DailyList, BillingHistory, BillingKVHistory, EDMPBillingHistory, EDMPEnrollment, EDMPEnrollmentDocument, HimiPrescription, PrescribedHeimi, PatientBill, OneClickBillingHistory, PrivateBillingHistory, PatientEnrollment, PatientParticipation, CardRaw, SdebmCatalog |

### User Story
As a system administrator, I want to run a one-time ETL process that migrates data from PostgreSQL to MongoDB, so that all existing data entities (employees, patients, scheins, timelines, billing histories, enrollments, prescriptions, catalogs) are transferred to the new document database.

### Acceptance Criteria
1. Given the ETL process is started, when it connects to both PostgreSQL and MongoDB, then data extraction begins from PostgreSQL source tables
2. Given each entity type, when the ETL builder processes it, then records are transformed and loaded into corresponding MongoDB collections via outbox event repos
3. Given the ETL process completes all builders, when all entities are processed, then the process exits cleanly with a success log message
4. Given an error during processing, when a builder fails, then the process panics with the error for operator investigation

### Technical Notes
- Source: `backend-core/service/etl/`
- Key functions: ETLManager.Process, builder types (NewEmployeeETL, NewPatientETL, NewScheinETL, NewTimelineETL, NewDoctorParticipateETL, NewDailyListETL, NewBillingKVHistoryETL, NewEDMPBillingHistoryETL, NewEDMPEnrollmentETL, NewHimiPrescriptionETL, NewPrescribedHeimiETL, NewPatientBillETL, NewOneClickBillingHistoryETL, NewPrivateBillingHistoryETL, NewPatientEnrollmentETL, NewPatientParticipationETL, NewCardRawETL, NewSdebmCatalogsETL)
- Integration points: PostgreSQL (source via GORM), MongoDB (target via repos), outboxevent (event tracking), all domain entity repos

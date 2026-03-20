# UnMatching: service_sync_cal_service

## File
`backend-core/service/sync_cal_service/`

## Analysis
- **What this code does**: Provides the CAL (Clinical Application Layer) synchronization service for syncing patient data, employee profiles, waiting rooms, and participation records with an external CAL system. Processes sync operations in batches, tracks sync progress via log entries, and coordinates across multiple repositories (BSNR, employee, patient, waiting room, participation).
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E8=Integration Services

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SYNC-CAL-SERVICE — CAL System Data Synchronization

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SYNC-CAL-SERVICE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | SyncCalLog, PatientProfile, EmployeeProfile, WaitingRoom, PatientParticipation |

### User Story
As a practice administrator, I want to synchronize patient data, employee profiles, waiting rooms, and participation records with an external CAL (Clinical Application Layer) system, so that data remains consistent between the practice management system and the external clinical system.

### Acceptance Criteria
1. Given a sync request, when I call `SyncCal`, then the sync log is retrieved, BSNR/room/staff/patient sync operations are executed in sequence, and the log is marked as done
2. Given BSNR data, when `syncBsnr` runs, then practice location data is synchronized with the CAL system
3. Given patient data, when `syncBatchPatients` runs, then patients are processed in batches of 50 to avoid memory issues
4. Given patient contracts, when `checkPatientContract` is called, then the system verifies the patient has an active contract of the specified type
5. Given a sync failure, when an error or panic occurs, then the sync log is marked as failed with the error message
6. Given a care provider, when `SetSyncCalDataOfCareProviderId` is called, then the sync configuration is established for that provider
7. Given a sync status request, when `GetStatusSyncCal` is called, then the current sync progress is returned

### Technical Notes
- Source: `backend-core/service/sync_cal_service/`
- Key functions: SyncCal, syncBsnr, syncRoom, syncStaff, syncBatchPatients, GetStatusSyncCal, SetSyncCalDataOfCareProviderId, checkPatientContract
- Integration points: CAL service, BSNR repo, employee profile repo, waiting room repo, patient profile repo, sync_cal_log_repo, patient_participation repo, external API

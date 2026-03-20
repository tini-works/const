# UnMatching: service_external

## File
`backend-core/service/external/`

## Analysis
- **What this code does**: Provides the external-facing service that exposes functionality to external systems (e.g., companion app, third-party integrations). Orchestrates BSNR lookups, timeline operations, patient profile management, patient participation, waiting room management, CAL integration, employee profile/admin services, and patient repository access for external API consumers.
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

## US-PROPOSED-EXTERNAL — External API Service for Companion App and Third-Party Integrations

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-EXTERNAL |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | BSNR, Patient, Employee, WaitingRoom, Timeline, Appointment |

### User Story
As an external system (companion app or third-party integration), I want to access practice management functions through a unified external API, so that I can look up BSNRs, manage patients, interact with waiting rooms, create timelines, and synchronize data with the CAL appointment system.

### Acceptance Criteria
1. Given an external API consumer, when GetListBSNR is called, then all practice location BSNRs are returned in the external response format
2. Given an external API consumer, when GetPatients is called with pagination, then patient profiles are returned with mapped external patient info format
3. Given a patient create/update event, when OnPatientCreate or OnPatientUpdate fires, then the patient data is synchronized to the CAL service and waiting room if applicable
4. Given an external API consumer, when GetWaitingRooms is called, then available waiting rooms with their assigned patients are returned
5. Given an external API consumer, when AddPatientToWaitingRoom is called, then the patient is assigned to the specified waiting room with CAL appointment check-in
6. Given an external request, when GetEmployees is called, then employee profiles with BSNR associations are returned in paginated format
7. Given an external request, when CheckExistPatient is called with patient criteria, then the system checks for existing matching patients

### Technical Notes
- Source: `backend-core/service/external/`
- Key functions: GetListBSNR, GetPatients, GetWaitingRooms, GetEmployees, CreateTimeline, OnPatientCreate, OnPatientUpdate, AddPatientToWaitingRoom, UnAssignPatientFromWaitingRoom, UpdatePatient, CheckExistPatient, Register (event hooks)
- Integration points: bsnr_service, timeline_service, patient_profile (BFF), patient_participation, waiting_room_service, CAL service, admin_service, employee profile service/repo, patient profile repo

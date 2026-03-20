# UnMatching: service_cal

## File
`backend-core/service/cal/`

## Analysis
- **What this code does**: Provides the CAL (Clinical Application Layer) integration service. Acts as an HTTP client to communicate with an external CAL service, handling authentication via bearer tokens. Integrates with catalog SDAV service and respects a feature flag for enabling/disabling CAL functionality.
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

## US-PROPOSED-CAL — Clinical Application Layer (CAL) Integration for Appointments and Resources

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CAL |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | Room, Staff, Practice, Patient, Appointment, TodoType |

### User Story
As a practice staff member, I want the system to synchronize rooms, staff, practices, patients, and appointments with the external CAL service, so that the clinical appointment layer stays consistent with practice management data.

### Acceptance Criteria
1. Given the CAL feature flag is enabled, when a room is created/updated/deleted, then the corresponding CRUD operation is forwarded to the external CAL service via HTTP
2. Given the CAL feature flag is enabled, when a staff member is created/updated or their status changes, then the staff data is synchronized with CAL
3. Given the CAL feature flag is enabled, when a practice is created/updated/deleted, then the practice data is synchronized with CAL
4. Given the CAL feature flag is enabled, when a patient is created/updated/deleted, then the patient data is synchronized with CAL
5. Given the CAL feature flag is disabled, when any CAL operation is called, then the operation silently succeeds without making external calls
6. Given a patient ID, when appointments are requested, then paginated appointment data is fetched from CAL
7. Given valid credentials, when a redirect link is requested, then a CAL authentication URL with login hints is generated

### Technical Notes
- Source: `backend-core/service/cal/`
- Key functions: CreateRoomCAL, UpdateRoomCAL, DeleteRoomCAL, CreateStaffCAL, UpdateStaffCAL, UpdateStaffStatus, CreatePracticeCAL, UpdatePracticeCAL, DeletePracticeCAL, CreatePatientCAL, UpdatePatientCAL, DeletePatientCAL, GetAppointments, UpdateStatusAppointment, CheckInAppointment, GetTodoTypes, GetRedirectCALLink, ManageResource
- Integration points: external CAL HTTP service (bearer token auth), settings_service (feature flag), catalog_sdav_service

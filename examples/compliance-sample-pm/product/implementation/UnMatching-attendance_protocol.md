# UnMatching: attendance_protocol

## File
`backend-core/app/app-core/api/attendance_protocol/`

## Analysis
- **What this code does**: Provides a patient attendance protocol service (AttendanceProtocolApp) that retrieves paginated attendance records filtered by date range, search query, and waiting room. Subscribes to patient profile change events to keep attendance data up to date. Used by practice staff to track patient visits and waiting room activity.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-ATTENDANCE_PROTOCOL — Patient Attendance Protocol Tracking

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-ATTENDANCE_PROTOCOL |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5: Practice Software Core |
| **Data Entity** | AttendanceProtocolModel, WaitingRoom |

### User Story

As a practice staff member, I want to view paginated attendance records filtered by date range, search query, and waiting room, so that I can track patient visits and manage waiting room activity effectively.

### Acceptance Criteria

1. Given an authenticated care provider member, when they request the attendance protocol with a date range and pagination, then the system returns matching attendance records with total count.
2. Given a search query is provided, when querying attendance records, then the system filters results to match the search term.
3. Given a specific waiting room is selected, when querying attendance records, then only records for that waiting room are returned.
4. Given a patient profile change event is published, when the attendance protocol service receives it, then it updates cached attendance data to reflect the changes.

### Technical Notes
- Source: `backend-core/app/app-core/api/attendance_protocol/`
- Key functions: GetAttendanceProtocol, HandleUpdatePatientProfile
- Integration points: patient_profile (patient profile change events), attendance_protocol/common (AttendanceProtocolModel), common (PaginationRequest)

# UnMatching: daily_list

## File
`backend-core/app/app-core/api/daily_list/`

## Analysis
- **What this code does**: Manages the daily patient list (Tagesliste) for the medical practice. Allows doctors to view their daily patient appointments with filtering by doctor, date range, patient type, and completion status. Supports creating/updating daily list entries for patients, toggling done status, showing timeline entries, and viewing recently seen patients. This is a core user-facing workflow feature.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] User-facing feature
- [ ] Infrastructure/utility
- [ ] Dead code

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-DAILY_LIST — Daily Patient List Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-DAILY_LIST |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 — Practice Core |
| **Data Entity** | DailyListModel, Patient |

### User Story
As a medical practitioner, I want to view and manage my daily patient list with filtering by doctor, date range, patient type, and completion status, so that I can efficiently track which patients I need to see and have already treated during the day.

### Acceptance Criteria
1. Given an authenticated care provider member, when they request the daily list with doctor IDs, date range, patient type filters, and pagination, then matching daily list entries are returned.
2. Given an authenticated care provider member, when they filter by undone entries only or timeline-only entries, then only the matching subset is returned.
3. Given an authenticated care provider member, when they request recently viewed patients, then the most recently accessed patient entries are returned.
4. Given an authenticated care provider member, when they toggle the done status of a daily list entry, then the entry's completion state is flipped and the updated entry is returned.
5. Given an authenticated care provider member, when they create or update a daily list entry for a patient (optionally linked to a Schein), then the entry is persisted.

### Technical Notes
- Source: `backend-core/app/app-core/api/daily_list/`
- Key functions: GetDailyList, ToggleDone, CreateOrUpdate
- Integration points: `service/domains/daily_list/common` (DailyListModel), `service/domains/api/patient_profile_common` (PatientType), `service/domains/api/common` (pagination)

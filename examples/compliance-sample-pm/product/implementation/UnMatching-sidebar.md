# UnMatching: sidebar

## File
`backend-core/app/app-core/api/sidebar/`

## Analysis
- **What this code does**: Provides the sidebar notification API for the UI. Returns default information including whether there are unsubmitted enrollments and pending PTV imports. Subscribes to sidebar response events and patient overview events, pushing real-time updates to users via WebSocket notifications at care-provider, user, device, and client levels.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SIDEBAR — Sidebar Notification and Status Indicators

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SIDEBAR |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 Practice Software Core |
| **Data Entity** | SidebarResponse (enrollment status, PTV import status) |

### User Story
As a practice staff member, I want the sidebar to display real-time notification indicators for unsubmitted enrollments and pending PTV imports, so that I am aware of outstanding tasks requiring attention without navigating away from my current workflow.

### Acceptance Criteria
1. Given an authenticated care provider member, when they request default sidebar information, then the response indicates whether there are unsubmitted enrollments, pending PTV imports, and additional status items
2. Given a sidebar event is published (e.g., enrollment status change), when the event is received by the sidebar subscriber, then the sidebar data is updated and pushed to the user via WebSocket
3. Given a patient overview event, when the event is received, then the sidebar updates are broadcast to care provider members, individual users, specific devices, and client sessions via WebSocket

### Technical Notes
- Source: `backend-core/app/app-core/api/sidebar/`
- Key functions: GetDefaultInformation, HandleEventSidebar, HandleEventForPatientOverview
- Integration points: WebSocket notifications (EventSidebarRepsonse) at care-provider, user, device, and client levels
- Subscribes to EVENT_SidebarRepsonse for real-time updates
- Requires CARE_PROVIDER_MEMBER role for GetDefaultInformation

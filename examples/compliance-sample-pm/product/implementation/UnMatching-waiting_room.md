# UnMatching: waiting_room

## File
`backend-core/app/app-core/api/waiting_room/`

## Analysis
- **What this code does**: Provides the waiting room event handling API for the app-core service. Subscribes to WaitingRoomChanged events and handles real-time notifications for waiting room changes (create, edit, remove, assign/unassign/update patient). Pushes WebSocket notifications to care provider members, individual users, devices, and clients.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-WAITING_ROOM — Real-Time Waiting Room Event Notifications

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-WAITING_ROOM |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | EventWaitingRoomChanged, WaitingRoomEventType |

### User Story
As a care provider member, I want to receive real-time notifications when waiting room changes occur (room created, edited, removed, patient assigned, unassigned, or updated), so that all staff members and connected devices are kept in sync with the current waiting room status.

### Acceptance Criteria
1. Given a waiting room event is published, when the event type is CreateWaitingRoom, EditWaitingRoom, or RemoveWaitingRoom, then all care provider members receive a WebSocket notification
2. Given a patient is assigned, unassigned, or updated in a waiting room, when the event is emitted, then notifications are pushed to care provider members, individual users, devices, and specific client sessions
3. Given a connected client with a valid session ID, when a waiting room change occurs, then the client receives the event via WebSocket with the correct room ID, patient ID, and event type
4. Given an invalid or missing session ID, when attempting to notify a client, then an appropriate error is returned

### Technical Notes
- Source: `backend-core/app/app-core/api/waiting_room/`
- Key functions: HandleEventWaitingRoomChanged (event subscriber)
- Integration points: NATS message subscription (WaitingRoomChanged event), WebSocket notifications (SendToCareProviderMembers, SendToUser, SendToDevice, SendToClient), socket_api service

# UnMatching: service_outboxevent

## File
`backend-core/service/outboxevent/`

## Analysis
- **What this code does**: Provides the transactional outbox pattern implementation for reliable event processing. Defines event types for entity deletion across many domains (patient, timeline, schein, billing history, enrollments, prescriptions, etc.), outbox event status tracking (pending/processed/failed), and repository operations for iterating pending events and marking them as done. Ensures eventual consistency for cross-service operations.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E5=Practice Software Core

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-OUTBOXEVENT — Transactional Outbox for Reliable Cross-Service Event Processing

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-OUTBOXEVENT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | OutboxEvent (patient, timeline, schein, billing_history, enrollment, prescription, etc.) |

### User Story
As a system operator, I want entity deletion events to be reliably tracked and processed across services using the transactional outbox pattern, so that eventual consistency is maintained when deleting patients, timelines, scheins, billing records, and other domain entities.

### Acceptance Criteria
1. Given an entity deletion, when an outbox event is created, then it is persisted with status "pending" and a new UUID
2. Given pending outbox events, when `IteratePendingIDs` is called, then each pending event ID is yielded to the callback for processing
3. Given processed events, when `MarkAsDone` is called with event IDs, then the status is updated to "processed"
4. Given a failed event, when processing fails, then the status is set to "failed" with an error message and retry count is tracked
5. Given deletion events for 19+ entity types (patient, timeline, schein, billing_history, card_raw, edmp_enrollment, himi_prescription, etc.), when the corresponding entity is deleted, then the appropriate event type is recorded

### Technical Notes
- Source: `backend-core/service/outboxevent/`
- Key functions: Create, UpdateStatus, IteratePendingIDs, MarkAsDone, DeleteWithOutboxEventRequest, DeleteByPatientIdWithOutboxEventRequest
- Integration points: MongoDB (outbox_events collection), generic Deleter/Finder interfaces, repos across patient, timeline, schein, billing, enrollment domains

# UnMatching: service_mongo-notify

## File
`backend-core/service/mongo-notify/`

## Analysis
- **What this code does**: Provides a MongoDB change stream watcher that synchronizes data to Typesense (search engine). Watches for MongoDB collection changes and triggers sync operations to keep the search index up-to-date. Runs as a standalone service process.
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

## US-PROPOSED-MONGO-NOTIFY — MongoDB to Typesense Search Index Synchronization

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-MONGO-NOTIFY |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | Timeline, ResumeToken |

### User Story
As a system operator, I want MongoDB collection changes to be automatically synchronized to the Typesense search engine, so that full-text search indexes remain up-to-date with the latest clinical data.

### Acceptance Criteria
1. Given the mongo-notify service is running, when a timeline document is inserted or updated in MongoDB, then the change is detected via change streams and synced to Typesense
2. Given a change stream watcher, when the service restarts, then it resumes from the last persisted resume token to avoid reprocessing
3. Given multiple watchers are registered, when `Watch` is called, then all watchers run concurrently via error group with panic recovery
4. Given a timeline deletion event, when the change is detected, then the corresponding Typesense document is removed

### Technical Notes
- Source: `backend-core/service/mongo-notify/`
- Key functions: Watch (WatcherManager), Register, TimelineSync (change stream processing)
- Integration points: MongoDB change streams, Typesense search engine, timeline_repo, ResumeTokenRepo

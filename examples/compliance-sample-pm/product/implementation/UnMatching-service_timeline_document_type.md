# UnMatching: service_timeline_document_type

## File
`backend-core/service/timeline_document_type/`

## Analysis
- **What this code does**: Provides management of timeline document types (custom clinical document categories). Supports creating, updating, and listing document types with active/inactive filtering. Initializes built-in document type commands and integrates with BSNR service and application settings for per-practice configuration.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E7=Clinical Documentation

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-TIMELINE-DOCUMENT-TYPE — Custom Timeline Document Type Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-TIMELINE-DOCUMENT-TYPE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7=Clinical Documentation |
| **Data Entity** | TimelineDocumentTypeEntity |

### User Story
As a practice administrator, I want to create, update, and manage custom timeline document types (clinical document categories), so that physicians can categorize clinical documentation entries with practice-specific document types.

### Acceptance Criteria
1. Given a document type name, when I call `CreateTimelineDocumentType`, then a new document type is created and associated with available BSNRs
2. Given an existing document type, when I call `UpdateTimelineDocumentType`, then the document type name and properties are updated
3. Given active document types, when I call `GetActiveTimelineDocumentType`, then only active document types are returned with their associated BSNRs
4. Given all document types, when I call `GetAllTimelineDocumentType`, then both active and inactive types are returned for administrative management
5. Given system initialization, when `InitBuiltinCommand` is called, then built-in default document type commands are created

### Technical Notes
- Source: `backend-core/service/timeline_document_type/`
- Key functions: CreateTimelineDocumentType, UpdateTimelineDocumentType, GetAllTimelineDocumentType, GetActiveTimelineDocumentType, InitBuiltinCommand
- Integration points: BSNR service, settings service (GetSettingsFlow, SaveSettingFlow), TimelineDocumentTypeRepo (MongoDB)

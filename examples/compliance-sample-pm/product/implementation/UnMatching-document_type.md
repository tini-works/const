# UnMatching: document_type

## File
`backend-core/app/app-core/api/document_type/`

## Analysis
- **What this code does**: Manages document type definitions used to categorize documents in the document management system. Provides CRUD operations: listing with search and pagination, creating new document types by name, updating existing types, and soft-deleting types. Acts as a supporting configuration catalog for the document management feature.
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

## US-PROPOSED-DOCUMENT_TYPE — Document Type Configuration

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-DOCUMENT_TYPE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 — Practice Core |
| **Data Entity** | DocumentType |

### User Story
As a practice administrator, I want to manage document type definitions used to categorize documents in the document management system, so that documents can be consistently classified and filtered by type.

### Acceptance Criteria
1. Given an authenticated user, when they list document types with optional search text and pagination, then matching document types are returned.
2. Given an authenticated user, when they create a new document type by name, then the type is persisted and returned.
3. Given an authenticated user, when they update an existing document type's name, then the type is modified.
4. Given an authenticated user, when they soft-delete a document type by ID, then the type is marked as deleted without physical removal.

### Technical Notes
- Source: `backend-core/app/app-core/api/document_type/`
- Key functions: ListDocumentType, CreateDocumentType, UpdateDocumentType, SoftDeleteDocumentType
- Integration points: `service/domains/api/document_type/common` (DocumentType), `service/domains/api/common` (pagination)

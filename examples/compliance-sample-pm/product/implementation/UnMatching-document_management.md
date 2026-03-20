# UnMatching: document_management

## File
`backend-core/app/app-core/api/document_management/`

## Analysis
- **What this code does**: Provides comprehensive document management for the medical practice. Supports document upload, import (including GDT and LDT format integration from companion desktop app), patient assignment, status tracking, read marking, deletion, and re-import of failed documents. Includes badge counts for unread documents, GDT export, lab results viewing with PDF generation, and document sync state management. Handles real-time notifications via socket events for import/export progress.
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

## US-PROPOSED-DOCUMENT_MANAGEMENT — Practice Document Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-DOCUMENT_MANAGEMENT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 — Practice Core |
| **Data Entity** | DocumentManagementModel, DocumentManagementItem |

### User Story
As a practice staff member, I want to upload, import (GDT/LDT), assign to patients, track status, and manage documents with badge counts and re-import capabilities, so that all practice documents are organized, accessible, and linked to the correct patient records.

### Acceptance Criteria
1. Given an authenticated user, when they create a document management entry with file info and status, then the entry is persisted and a presigned upload URL is returned.
2. Given an authenticated user, when they list documents with filters (text, assignment status, date range, status, patient IDs, sender IDs) and pagination, then matching documents are returned.
3. Given an authenticated user, when they assign a document to a patient with sender, type, and description, then the document is linked to the patient.
4. Given an authenticated user, when they mark a document as read, then the read status is updated.
5. Given an authenticated user, when they delete a document (optionally with patient context), then the document is removed.
6. Given an authenticated user, when they delete or re-import failed documents (by IDs or all), then the failed entries are cleaned up or retried.
7. Given an authenticated user, when they request document badge counts, then unassigned, fail, and total counts are returned.
8. Given an authenticated user, when they upload files, then the documents are queued for processing.
9. Given an authenticated user, when they export a GDT document, then the export is performed and results are notified via socket events.
10. Given the system, when GDT or LDT documents are imported from the companion app, then they are processed and import results are notified in real-time.
11. Given an authenticated user, when they request lab results or lab results PDF, then the data is returned for display.

### Technical Notes
- Source: `backend-core/app/app-core/api/document_management/`
- Key functions: CreateDocumentManagement, ListDocumentManagement, AssignPatientDocument, MarkReadDocumentManagement, DeleteDocumentManagement, UploadDocumentManagement, GetDocumentBadge, ReImportFailDocument, ExportGdtDocument, ProcessImportGdtDocuments, ProcessImportLdtDocuments, GetLabResults, GetLabResultsPDF
- Integration points: `service/domains/api/document_management/common`, `service/domains/api/document_type/common`, `service/domains/api/patient_profile_common`

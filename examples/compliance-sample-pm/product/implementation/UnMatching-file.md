# UnMatching: file

## File
`backend-core/app/app-core/api/file/`

## Analysis
- **What this code does**: Provides file management operations via MinIO presigned URLs. Supports generating presigned upload URLs, presigned download (GET) URLs, and deleting files. Used as a shared file storage service for other features that need file upload/download capabilities.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-FILE — File Storage Management via Presigned URLs

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-FILE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | File (MinIO Object) |

### User Story
As a care provider member or admin, I want to upload, download, and delete files through secure presigned URLs, so that the system can manage file attachments for various features without direct storage access.

### Acceptance Criteria
1. Given a valid bucket and object name, when the user requests a presigned upload URL, then the system returns a time-limited presigned URL for uploading the file to MinIO
2. Given a valid bucket and object name, when the user requests a presigned download URL, then the system returns a time-limited presigned GET URL for downloading the file
3. Given an existing file name, when the user requests deletion, then the system removes the file from storage

### Technical Notes
- Source: `backend-core/app/app-core/api/file/`
- Key functions: GetPresignedURL (upload), GetPresignedGetURL (download), DeleteFile
- Integration points: MinIO object storage; secured for both CARE_PROVIDER_ADMIN and CARE_PROVIDER_MEMBER roles

# UnMatching: catalog_sdik

## File
`backend-core/app/app-core/api/catalog_sdik/`

## Analysis
- **What this code does**: Manages the SDIK (Stammdatei Institutionskennzeichen) catalog, which is the German institutional identifier directory for insurance companies and healthcare institutions. Provides CRUD operations, search by IK number, validation of updates, and termination info retrieval. Supports filtering by self-created entries and date-based lookups.
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

## US-PROPOSED-CATALOG_SDIK — Institutional Identifier (SDIK) Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_SDIK |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 — Practice Core |
| **Data Entity** | SdikCatalog |

### User Story
As a practice administrator, I want to manage the institutional identifier directory (Stammdatei Institutionskennzeichen) for insurance companies and healthcare institutions, so that correct IK numbers are available for billing and communication with payers.

### Acceptance Criteria
1. Given an authenticated user, when they search for SDIK entries with text value and pagination (optionally filtering by self-created), then matching institutional records are returned with total count.
2. Given an authenticated user, when they create a new SDIK catalog entry, then the record is persisted and returned.
3. Given an authenticated user, when they update an existing SDIK entry, then the record is modified after validation.
4. Given an authenticated user, when they validate an update with IK number, then field-level validation errors are returned if applicable.
5. Given an authenticated user, when they search by IK number or by search type with date, then matching institutions are returned.
6. Given an authenticated user, when they look up an SDIK entry by IK number, then the specific institutional record is returned.
7. Given an authenticated user, when they request termination info for a list of IK numbers, then a map of termination statuses is returned.
8. Given an authenticated user, when they delete an SDIK entry with termination date, then the record is removed.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_sdik/`
- Key functions: CreateSdikCatalog, GetSdikCatalogs, UpdateSdikCatalog, IsValidUpdateSdik, DeleteSdikCatalog, SearchSdikCatalog, GetSdikCatalogByIkNumber, GetTerminateInfoOfListSdik
- Integration points: `service/domains/api/catalog_sdik_common` (SdikCatalog), `service/domains/api/common` (pagination, FieldError)

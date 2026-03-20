# UnMatching: catalog_uv_goa

## File
`backend-core/app/app-core/api/catalog_uv_goa/`

## Analysis
- **What this code does**: Manages the UV-GOA (Unfallversicherung - Gebuehrenordnung fuer Aerzte) catalog, the fee schedule for occupational accident insurance billing. Provides CRUD operations, search by code/codes, validation of updates, and filtering by self-created and general entries with date-based lookups. This is a user-facing billing reference catalog for workers' compensation cases.
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

## US-PROPOSED-CATALOG_UV_GOA — UV-GOA Fee Schedule Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_UV_GOA |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1 — Billing |
| **Data Entity** | UvGoaCatalog, UvGoaItem |

### User Story
As a practice administrator, I want to manage the UV-GOA (occupational accident insurance fee schedule) catalog with CRUD operations, code-based lookups, and update validation, so that workers' compensation billing uses correct fee schedule entries.

### Acceptance Criteria
1. Given an authenticated user, when they search for UV-GOA entries with text, pagination, and optional self-created filter, then matching fee schedule records are returned with total count.
2. Given an authenticated user, when they create a new UV-GOA catalog entry, then the record is persisted and returned.
3. Given an authenticated user, when they update an existing UV-GOA entry, then the record is modified and returned.
4. Given an authenticated user, when they validate an update, then field-level validation errors are returned if applicable.
5. Given an authenticated user, when they delete a UV-GOA entry by ID, then the record is removed.
6. Given an authenticated user, when they search UV-GOA items by value with date and general/custom filter, then matching items are returned.
7. Given an authenticated user, when they look up a UV-GOA entry by code or multiple codes, then the corresponding fee schedule records are returned.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_uv_goa/`
- Key functions: CreateUvGoaCatalog, GetUvGoaCatalogs, UpdateUvGoaCatalog, IsValidUpdateUvGoa, DeleteUvGoaCatalog, SearchUvGoaItems, GetUvGoaCatalogByCode, GetUvGoaCatalogByCodes
- Integration points: `service/domains/api/catalog_uv_goa_common` (UvGoaCatalog, UvGoaItem), `service/domains/api/common` (pagination, FieldError)

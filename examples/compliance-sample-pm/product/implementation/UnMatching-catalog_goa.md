# UnMatching: catalog_goa

## File
`backend-core/app/app-core/api/catalog_goa/`

## Analysis
- **What this code does**: Provides a GOA (Gebuehrenordnung fuer Aerzte / German physician fee schedule) catalog management service (GoaCatalogApp). Supports full CRUD operations on GOA catalog entries, searching GOA items by value and date, retrieving GOA chapters, looking up by GOA number, and validating updates. Used by practitioners to manage and look up private billing fee schedule codes.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-CATALOG_GOA — GOA Fee Schedule Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_GOA |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1: Billing Documentation |
| **Data Entity** | GoaCatalog, GoaItem, Chapter |

### User Story

As a practitioner, I want to manage the GOA (physician fee schedule) catalog including creating, reading, updating, deleting, searching, and validating entries, so that I can maintain accurate private billing fee schedule codes for patient billing.

### Acceptance Criteria

1. Given GOA catalog data, when the practitioner creates a new entry, then the system saves and returns the new GOA catalog item.
2. Given optional search value, self-created filter, pagination, and code exclusions, when the user lists GOA catalogs, then the system returns paginated results with total count.
3. Given no parameters, when the user requests GOA chapters, then the system returns all available chapter definitions.
4. Given updated GOA catalog data, when the practitioner updates an entry, then the system validates and saves the changes.
5. Given GOA catalog data to validate, when the practitioner checks validity, then the system returns any field-level validation errors.
6. Given a GOA catalog ID, when the practitioner deletes an entry, then the system removes the catalog item.
7. Given a search value and optional date, when the practitioner searches GOA items, then the system returns matching GOA items.
8. Given a GOA number, when the user looks up by number, then the system returns the matching catalog entry.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_goa/`
- Key functions: CreateGoaCatalog, GetGoaCatalogs, GetGoaChapters, UpdateGoaCatalog, IsValidUpdateGoa, DeleteGoaCatalog, SearchGoaItems, GetGoaCatalogByGoaNumber
- Integration points: catalog_goa_common (GoaCatalog, GoaItem, Chapter), common (PaginationRequest, FieldError)

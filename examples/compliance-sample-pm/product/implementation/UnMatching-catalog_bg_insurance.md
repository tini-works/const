# UnMatching: catalog_bg_insurance

## File
`backend-core/app/app-core/api/catalog_bg_insurance/`

## Analysis
- **What this code does**: Provides a BG (Berufsgenossenschaft / occupational insurance) catalog lookup service (BGInsuranceCatalogApp). Supports searching BG insurance providers by IK number or name with date filtering, listing all BG insurances with pagination and self-created filter, looking up by IK number, and creating custom BG insurance entries. Used for occupational injury/illness billing workflows.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-CATALOG_BG_INSURANCE — BG Insurance Provider Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_BG_INSURANCE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1: Billing Documentation |
| **Data Entity** | BGInsuranceCatalog |

### User Story

As a practice staff member, I want to search, browse, and look up occupational insurance (BG) providers by IK number or name, list all BG insurances with pagination and self-created filter, and create custom BG insurance entries, so that I can accurately assign occupational insurers to BG billing cases.

### Acceptance Criteria

1. Given a search value, search type (IK number or name), and a selected date, when the user searches for BG insurances, then the system returns matching BG insurance catalog entries valid for that date.
2. Given an IK number, when the user looks up a BG insurance by IK number, then the system returns the matching BG insurance entry.
3. Given optional search value, self-created filter, and pagination, when the user lists BG insurances, then the system returns paginated results with total count.
4. Given BG insurance details, when the user creates a custom BG insurance entry, then the system saves and returns the new catalog entry.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_bg_insurance/`
- Key functions: SearchBGInsurance, GetBGInsuranceByIkNumber, GetBGInsurance, CreateBGInsurance
- Integration points: catalog_bg_insurance_common (BGInsuranceCatalog), common (PaginationRequest)

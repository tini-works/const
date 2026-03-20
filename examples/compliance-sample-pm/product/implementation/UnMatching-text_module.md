# UnMatching: text_module

## File
`backend-core/app/app-core/api/text_module/`

## Analysis
- **What this code does**: Provides an API for managing text modules (reusable text templates/shortcuts) in the practice. Exposes endpoints to get text modules with pagination and filtering by use-for type, and to check for invalid OmimG chain references within text modules based on a selected date.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-TEXT_MODULE — Text Module (Template/Shortcut) Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-TEXT_MODULE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 Practice Software Core |
| **Data Entity** | TextModule, OmimGChain |

### User Story
As a practice staff member, I want to search and retrieve reusable text modules (templates/shortcuts) filtered by usage type, and validate OmimG chain references within those modules, so that I can efficiently insert standardized text into documentation and ensure referenced codes remain valid.

### Acceptance Criteria
1. Given a search query, pagination parameters, and optional use-for type filters, when the user requests text modules, then matching text modules are returned with pagination metadata
2. Given a selected date, when the user checks for invalid OmimG chain references, then text modules containing invalid OmimG chain references for that date are returned with their IDs and shortcuts

### Technical Notes
- Source: `backend-core/app/app-core/api/text_module/`
- Key functions: GetTextModules, GetInvalidOmimGChain
- Integration points: `service/domains/api/text_module_common` (TextModulePaginationRequest, TextModulePaginationResponse, TextModuleUseFor)
- Both endpoints require authentication (no additional role restriction beyond IsAuthenticated)

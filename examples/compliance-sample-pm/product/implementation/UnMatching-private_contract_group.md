# UnMatching: private_contract_group

## File
`backend-core/app/app-core/api/private_contract_group/`

## Analysis
- **What this code does**: Manages private contract groups used for organizing private billing service codes (GOA). Provides full CRUD operations: create, list with search/pagination, update, delete, and get by ID. Also supports listing available group names and initializing default contract group data. These groups categorize private billing service codes for easier management.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-PRIVATE_CONTRACT_GROUP — Private Contract Group Management for GOA Billing

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-PRIVATE_CONTRACT_GROUP |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1 Billing Documentation |
| **Data Entity** | PrivateContractGroup, PrivateContractGroupItem |

### User Story
As a practice administrator, I want to manage private contract groups that organize GOA (private billing) service codes into logical categories, so that private billing codes are structured and easier to locate during invoicing.

### Acceptance Criteria
1. Given an authenticated user, when they submit a new private contract group with valid data, then the group is created and returned as a PrivateContractGroupItem
2. Given existing private contract groups, when the user requests the list with search text and pagination, then matching groups are returned with a total count
3. Given an existing private contract group ID, when the user requests an update with modified data, then the group is updated and the updated item is returned
4. Given an existing private contract group ID, when the user requests deletion, then the group is removed
5. Given an existing private contract group ID, when the user requests it by ID, then the full group detail is returned
6. Given the system has contract groups, when the user requests available group names, then a list of group name strings is returned
7. Given initial system setup, when InitPrivateContractGroupData is called, then default contract group data is seeded

### Technical Notes
- Source: `backend-core/app/app-core/api/private_contract_group/`
- Key functions: CreatePrivateContractGroup, GetListPrivateContractGroup, UpdatePrivateContractGroup, DeletePrivateContractGroup, GetPrivateContractGroup, GetListGroup, InitPrivateContractGroupData
- Integration points: `service/domains/private_contract_group/common`, `service/domains/api/common` (PaginationRequest)

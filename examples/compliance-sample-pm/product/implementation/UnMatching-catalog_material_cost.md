# UnMatching: catalog_material_cost

## File
`backend-core/app/app-core/api/catalog_material_cost/`

## Analysis
- **What this code does**: Provides a CRUD API for managing material cost catalog entries used in medical billing. Supports creating, updating, and searching material cost records with pagination. The catalog stores cost data for materials used in medical practice procedures.
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

## US-PROPOSED-CATALOG_MATERIAL_COST — Material Cost Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_MATERIAL_COST |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1 — Billing |
| **Data Entity** | MaterialCostCatalog |

### User Story
As a practice administrator, I want to manage a catalog of material costs used in medical procedures, so that material expenses can be accurately tracked and included in billing.

### Acceptance Criteria
1. Given an authenticated user, when they search for material costs with a text value and pagination, then matching material cost entries are returned with a total count.
2. Given an authenticated user, when they create a new material cost entry, then the entry is persisted and returned with its generated ID.
3. Given an existing material cost entry, when the user updates it, then the modified entry is returned.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_material_cost/`
- Key functions: CreateMaterialCost, UpdateMaterialCost, GetMaterialCosts
- Integration points: `service/domains/api/catalog_material_cost_common` (MaterialCostCatalog), `service/domains/api/common` (pagination)
